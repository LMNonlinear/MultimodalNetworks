close all
%%
Fs = 1000;
t = 0:1/Fs:0.296;
% x = cos(2*pi*t*100)+0.25*randn(size(t));
tau = 1/400;
% y = cos(2*pi*100*(t-tau))+0.25*randn(size(t));
% x = cos(2*pi*120*(t-tau))+0.25*randn(size(t));
% y=cos(2*pi*100*(t-tau))+0.25*randn(size(t));
% y =sigmoid( cos(2*pi*50*(t-tau))+0.25*randn(size(t)));
% x = cos(2*pi*100*(t-tau));
% y=cos(2*pi*100*(t-tau));
%%
mode=2
%%
switch mode
    case 1
        x = 0.5*randn(size(t));
        ys =sigmoid(x);
        y=logit(ys);
        subplot(4,1,1)
        plot(x');hold on
        plot(ys');
        title('signal')
        legend('Gaussian noise','noise passed sigmoid function')
        subplot(4,1,2)
        % cpsd(x,ys,[],[],[],Fs);hold on
        % cpsd(x,y,[],[],[],Fs)
        pwelch(x,[],[],[],Fs);
        legend('Gaussian noise')
        subplot(4,1,3)
        pwelch(ys,[],[],[],Fs)
        legend('noise passed sigmoid function')
        subplot(4,1,4)
        cpsd(x,ys,[],[],[],Fs);
        legend('cross spectrum')
        
        
        
        %%
    case 2
        x = cos(2*pi*t*20)+0.25*randn(size(t));
        y = cos(2*pi*20*(t-tau))+0.25*randn(size(t));
        ys =sigmoid(y);
        subplot(3,1,1)
        %         plot(x');
        hold on
        plot(y');
        plot(ys');
        legend('x=cos(2*pi*t*100)+0.25*randn(size(t))' ,'y=cos(2*pi*100*(t-tau))+0.25*randn(size(t))','ys=sigmoid(cos(2*pi*100*(t-tau))+0.25*randn(size(t)))');
        
        title('signal')
        subplot(3,1,2)
        cpsd(x,y,[],[],[],Fs);
        legend(['x=cos(2*pi*t*100)+0.25*randn(size(t))',  newline ,'y=cos(2*pi*100*(t-tau))+0.25*randn(size(t))']);
        subplot(3,1,3)
        cpsd(x,ys,[],[],[],Fs);
        legend(['x=cos(2*pi*t*100)+0.25*randn(size(t))',  newline ,'ys=sigmoid(cos(2*pi*100*(t-tau))+0.25*randn(size(t)))']);
end


%%
close all
Fs = 1000;
t = 0:1/Fs:0.296;
tau = 1/400;
megSignal=zeros(2,length(t));
megSignal(1,:)=cos(2*pi*100*t)+0.25*randn(size(t));
megSignal(2,:)=cos(2*pi*100*(t-tau))+0.25*randn(size(t));
[pxy,f]=cpsd(megSignal',megSignal',[],[],[],Fs,'mimo'); %should not use mimo?
plot(f,abs(pxy(:,1,2)));hold on;
plot(f,abs(pxy(:,2,1)))
%% coherence
figure
cxy=[];
for i=1:size(pxy,2)
    cxy(:,i,:)=(abs(pxy(:,i,:)).^2)./real(pxy(:,i,i));
end
for j=1:size(pxy,3)
    cxy(:,:,j)=cxy(:,:,j)./real(pxy(:,j,j));
end
fs=250;
tm=0:1/fs:30-(1/fs);
% f=linspace(0,125,size(cxy_mino,1));

plot(f,abs(cxy(:,1,2)));hold on;
plot(f,abs(cxy(:,2,1)))

%%
close all
Fs = 1000;
Fm=Fs/2;
t = 0:1/Fs:0.296;
tau = 1/400;
deltaf=Fs/length(t);
megSignal=zeros(2,length(t));
megSignal(1,:)=cos(2*pi*100*t)+0.25*randn(size(t));
megSignal(2,:)=cos(2*pi*100*(t-tau))+0.25*randn(size(t));
[pxy,f,Ns,PSD] = xspectrum(megSignal,Fs,Fm,deltaf);
% plot(f,squeeze(abs(pxy(1,2,:)))); hold on
[pxy,f]=cpsd(megSignal',megSignal',[],[],[],Fs,'mimo');
plot(f,abs(pxy(:,1,2)));
%%
close all
Fs = 1000;
Fm=Fs/2;
t = 0:1/Fs:5.296;
tau = 1/400;
deltaf=Fs/length(t);
megSignal=zeros(2,length(t));
megSignal(1,:)=cos(2*pi*100*t)+0.25*randn(size(t));
megSignal(2,:)=cos(2*pi*100*(t-tau))+0.25*randn(size(t));
megSignal(3,:)=cos(2*pi*100*t)+0.25*randn(size(t));
megSignal(4,:)=cos(2*pi*100*(t-tau))+0.25*randn(size(t));
% for i=1:size(megSignal,1)    
%     for j=1:size(megSignal,1)
%         if i<=j
%             [pxy(i,j,:),f(i,j,:)]=cpsd(megSignal(i,:)',megSignal(j,:)',[],[],[],Fs);
%         end
%     end
% end
% nfft = max(256,2^nextpow2(length(t)));
%  select = 1:nfft/2+1;  
 
[pxy(1,1,:),f]=cpsd(megSignal(1,:)',megSignal(1,:)',[],[],[],Fs);
pxy=zeros(size(megSignal,1) ,size(megSignal,1) ,size(pxy,3));
for i=1:size(megSignal,1)    
    for j=1:size(megSignal,1)
        if i<=j
            [pxy(i,j,:),f]=cpsd(megSignal(i,:)',megSignal(j,:)',[],[],[],Fs);
        end
    end
end
 
% [pxy,f,Ns,PSD] = xspectrum(megSignal,Fs,Fm,deltaf);
% % plot(f,squeeze(abs(pxy(1,2,:)))); hold on
% [pxy,f]=cpsd(megSignal',megSignal',[],[],[],Fs,'mimo');
% plot(f,abs(pxy(:,1,2)));
%%
  Fs = 1000;   t = 0:1/Fs:.296;
  x = cos(2*pi*t*200);  % A cosine of 200Hz plus noise
  y = cos(2*pi*t*100);  % A cosine of 100Hz plus noise
%   cpsd(x,y,[],[],[],Fs,'twosided');    % Uses default window, overlap & NFFT. 
  cpsd(x,y,[],[],[],Fs);    % Uses default window, overlap & NFFT. 
