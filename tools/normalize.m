function y = normalize(x)
y =(x-min(x))./(max(x)-min(x));
y=0.9*(y-0.5)+0.5;

% y =x./(max(x)-min(x));
% y=y-mean(x)+0.5;
% y=y';
% for i=1:size(x,2)
%     temp=x(:,i);
% %     y(:,i)=(temp-mean(temp))./(max(temp)-min(temp));
%         y(:,i)=(temp-min(temp))./(max(temp)-min(temp));
% 
% end
y=y';
end
