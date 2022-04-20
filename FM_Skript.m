clearvars
close all
clc
% Liest die Daten aus dem File und gibt die abgetastete Daten zurück
[v_stereo, fs] = audioread('/home/chi/Desktop/Programs/Matlab/Juri/AK2_FM_Modulation/mozart.mp3');
% Die abgetastete Werte sind dem Vektor v_in zugewiesen
v_in = v_stereo(:,1);

%% Filter Parameter
Ts = 1/fs;  % Abtastperiode

apass = 1.;    % max. Dämpfung im Durchlassbereich
astop = 50;     % min. Dämpfung im Sperrbereich
fpass = 6e3;    % Durchlassgrenze
fstop = 8e3;    % Sperrgrenze

%% Filter entwerfen
% genau wie bei analogen Filtern mit folgenden Unterschieden:
%  * Durchlass- und Sperrgrenzen werden auf die halbe Abtastrate bezogen
%  * kein 's' als letzten Parameter; 's' kennzeichnet analogen Filterentwurf
[N,Wn] = buttord(2*fpass/fs, 2*fstop/fs,apass,astop);
% Quotienten von Zähler und Nenner des Polynomes
[B,A] = butter(N,Wn);
% Definition von Übertragungsfunktion; Achtung: nicht Parameter Ts vergessen!
H = tf(B,A,Ts);      

figure(1);
bode(H);     % zeichne Bodediagramm
grid on;
legend('H', "location", "southwest");
% Filtert Inputsignal mit Hilfe von Transferfunktion, die mit Zähler und
% * Nenner Quotienen definiert ist.
v_out = filter(B,A,v_in);
% Maximum
v_out_max = max(abs(v_out));
%
v_out = v_out./v_out_max;
%  writes a matrix of audio data, v_out, with sample rate fs to a file called mozart_edit.wav
audiowrite('mozart_edit.wav',v_out,fs);

% A = 3;          % Amplitude
% fsig = 1e3;     % Signalfrequenz
% Tmax = 1;       % Dauer des Sinussignals
% 
% 
% k = 0:1:floor(Tmax/Ts);     % definiere diskreten Zeitvektor (Samplenummern) für gesamte Signaldauer
% 
% v_out = transpose(A * sin(2*pi*fsig*k*Ts));     % berechne Sinussignal;
%                                             % 'transpose' um Spaltenvektor (= Kanaldaten) zu erhalten
% 
% v_out = 1. * v_out/max(abs(v_out));    % Signal auf Größe <1 skalieren um clipping zu vermeiden (konkret abs(u)<=0.8)

%% FM-Modulation

wt = 2*pi*8e3;  % Kreisfrequenz des Trägersignals
K = 3000;

N = length(v_out);
% returns an N-by-1 array of zeros where N and 1 indicate the size of each dimension.
% we need it to make our calculations simpliar for matlab, because the size
% of an array is already known
% Erstellen eines leeren Vektors
phi = zeros(N,1);
% see formula! 
phi(1) = K*v_out(1)*Ts + wt*Ts;
phi(1) = mod(phi(1),2*pi);

for i=2:1:N
    
    phi(i) = phi(i-1) + K*v_out(i)*Ts + wt*Ts;
    % cut 2*pi off
    phi(i) = mod(phi(i),2*pi); 
    
end
% Sendersignal auf das Trägersignal aufmodulieren.
v_fm = sin(phi);
setoptions(h, 'FreqUnits', 'kHz', 'PhaseVisible', 'off', 'XLim', {[1, 1000]}, 'YLim', {[-40, 20]});
plot(1:1:N,v_out,1:1:N,v_fm)
% Das FM-Signal im .wav-File abspeichern
audiowrite('mozart_fm.wav',v_fm,fs);





