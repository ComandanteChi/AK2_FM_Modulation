%*****************************************************************************
% @file           : FM-Modulation.m
% @brief          : Frequenzmodulation eines Audiosignals.
%*****************************************************************************
%*****************************************************************************
%	PROJEKTNAME - FM-Modulation
%
%	PROJEKTTEAM - Juri, Milad, Alexei
%
%	DATUM -     Beginn 29.03.2022
%            Abschluss 08.05.2022
%
%	BESCHREIBUNG - Dieses Skript ist für FM-Modulation zuständig und muss
%   vor "FM-Demodulation.m" ausgeführt werden. Das Programm besteht aus 
%   folgenden Abschnitten:
%
%           1) Audiosignal abtasten
%           2) Filter Parameter
%           3) Filterentwurf
%           4) Phase Berechnung
%           5) FM-Modulation
%*****************************************************************************

clearvars
close all
clc

%% Audiosignal abtasten
% Liest das Audiosignal und kehrt abgetastete Werte und Abtastrate zurück.
%!ACHTUNG! Geben Sie in "audioread" einen genauen Standort von ihrer
%Audiodatei!
[v_stereo, fs] = audioread('/home/chi/Desktop/Programs/Matlab/Juri/AK2_FM_Modulation/mozart.mp3');
% Die abgetastete Werte sind dem Vektor v_in zugewiesen
v_in = v_stereo(:,1);

%% Filter Parameter
Ts = 1/fs;  % Abtastperiode

apass = 1.;    % max. Dämpfung im Durchlassbereich
astop = 50;     % min. Dämpfung im Sperrbereich
fpass = 6e3;    % Durchlassgrenze
fstop = 8e3;    % Sperrgrenze

%% Filterentwurf
% genau wie bei analogen Filtern mit folgenden Unterschieden:
%  * Durchlass- und Sperrgrenzen werden auf die halbe Abtastrate bezogen
%  * kein 's' als letzten Parameter; 's' kennzeichnet analogen Filterentwurf
[N,Wn] = buttord(2*fpass/fs, 2*fstop/fs,apass,astop);
% Quotienten von Zähler und Nenner des Polynomes
[B,A] = butter(N,Wn);
% Definition von Übertragungsfunktion
H = tf(B,A,Ts);

% Bodediagramm
figure(1);
bode(H);     
grid on;
legend('H', "location", "southwest");

% Input Signal wird mit Butterworth filter gefitert
v_out = filter(B,A,v_in);
% Signal normalisieren
v_out_max = max(abs(v_out));
v_out = v_out./v_out_max;
% Abspeichern des (gefilterten&normalisierten) Signals in einer .wav-Datei.
audiowrite('mozart_edit.wav',v_out,fs);

%% Phase Berechnung
wt = 2*pi*8e3;  % Kreisfrequenz des Trägersignals
K = 3000;   % discrete time vector
N = length(v_out);  % Länge des gefilterten Signals.
% Deklaration und definition eines nullbasierten Arrays
phi = zeros(N,1);
%  Berechnung der Phase "phi"
%  und Abschneidung der 2 pi Anteile
phi(1) = K*v_out(1)*Ts + wt*Ts;
phi(1) = mod(phi(1),2*pi);
for i=2:1:N    
    phi(i) = phi(i-1) + K*v_out(i)*Ts + wt*Ts;
    phi(i) = mod(phi(i),2*pi);     
end
%% FM-Modulation
% Sendersignal auf das Trägersignal modulieren.
v_fm = sin(phi);
% Sendersignal und FM-Signal plotten.
figure(2);
plot(1:1:N,v_out,1:1:N,v_fm);
% Das FM-Signal im .wav-File abspeichern
audiowrite('mozart_fm.wav',v_fm,fs);





