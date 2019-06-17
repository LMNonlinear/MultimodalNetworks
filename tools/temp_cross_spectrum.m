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




