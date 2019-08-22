function plotEEG(h,tspan,EEG)
Fs=1/h;
N=length(tspan);
npsegment=2.56/h;

figure
subplot(311)
plot(tspan,EEG)

subplot(312)
TFR = morletcwt(EEG', 3:0.5:80, 1/h, 7);
imagesc(tspan, 3:0.5:80, abs(TFR).^2'); axis xy

subplot(313)
[Pxx,F] = pmtm(EEG,10,256,1/h);
semilogy(F,Pxx);xlim([0 50]);
