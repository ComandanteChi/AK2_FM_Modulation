%*****************************************************************************
% @file           : FM-Demodulation.m
% @brief          : Demodulation eines FM-Signals.
%*****************************************************************************
%*****************************************************************************
%	PROJEKTNAME - FM-Demodulation
%
%	PROJEKTTEAM - Juri, Milad, Alexei
%
%	DATUM -     Beginn 29.03.2022
%            Abschluss 08.05.2022
%
%	BESCHREIBUNG - Dieses Skript ist für FM-Demodulation zuständig und muss
%   nach dem Skript "FM-Modulation.m" ausgeführt werden. Das Programm besteht
%   aus folgenden Abschnitten:
%
%           1)FM-Signal abtasten
%           2)Übergang von FM zu AM
%           3)Impulsantort
%           4)Analytisches Signal "v_hilb"
%           5)Berechnung des Sendersignals
%           6)Spektrum berechnen (davor)
%           7)Filterentwurf
%           8)Letzte Vorbereitungen
%           9)Spektrum berechnen (danach)
%*****************************************************************************

clearvars
close all
clc
%% FM-Signal abtasten  
% Liest das Audiosignal und kehrt abgetastete Werte und Abtastrate zurück.
%!ACHTUNG! Geben Sie in "audioread" einen genauen Standort von ihrer
%Audiodatei!
[v_in, fs] = audioread('/home/chi/Demo/AK2_FM_Modulation/audio/mozart_fm.wav');
Ts = 1/fs;  % Abtastperiode
%% Übergang von FM zu AM
v_diff = diff(v_in);
%% Impulsantort
% Die Länge des Array ausrechnen
N = length(v_diff);
% FIR-Filter Ordnung (ungerade)
M = 199;    
% Deklaration und definition eines nullbasierten Arrays
hilb_filter_coeff = zeros(M+1,1);

for i=1:1:M+1
    hilb_filter_coeff(i) = 1/(pi*(i-M/2-1));
end
hilb_imag = filter(hilb_filter_coeff,1,v_diff);

%% Analytisches Signal "v_hilb"
v_diff = cat(1,zeros((M+1)/2,1),v_diff);
hilb_imag = cat(1,hilb_imag,zeros((M+1)/2,1));
v_hilb = v_diff + 1i*hilb_imag;
%% Berechnung des Sendersignals
v_out = abs(v_hilb); % calculate the absolute value 

%% Spektrum berechnen (davor)
uspec = fft(v_out);         % berechne Fast Fourier Transform (= digitale Form der Fourier-Transformation) von Signal u
N = length(uspec);      % bestimme Anzahl von Elementen in Spektrumvektor = Anzahl von Samples in u

umagspec = abs(uspec);               % bestimme Betragsspektrum

 umagspec = 2/N*umagspec(1:N/2);     % bestimme einseitiges (d.h., nur positive Frequenzen) Betragsspektrum
                                          % und skaliere (Faktor 2/N) auf physikalische Amplitudenwerte

umagspec(1) = umagspec(1)/2;        % korrigiere Gleichanteil

Df = fs/N;          % Frequenzauflösung
f = 0:Df:(N-1)*Df;  % Beschriftung der Frequenzachse
f = f(1:N/2);       % entferne negativen Frequenzanteil

figure(2)
stem(f,umagspec)
grid on

%% Filterentwurf
apass = 1.;    % max. Dämpfung im Durchlassbereich
astop = 50;     % min. Dämpfung im Sperrbereich
fpass = 6e3;    % Durchlassgrenze
fstop = 8e3;    % Sperrgrenze
% Genau wie bei analogen Filtern mit folgenden Unterschieden:
%  * Durchlass- und Sperrgrenzen werden auf die halbe Abtastrate bezogen
%  * kein 's' als letzten Parameter; 's' kennzeichnet analogen Filterentwurf
[N,Wn] = buttord(2*fpass/fs, 2*fstop/fs,apass,astop);
[B,A] = butter(N,Wn);
v_out = filter(B,A,v_out);

%% Letzte Vorbereitungen
% Rauschen am Anfang und am Ende abschneiden
v_out = v_out(5000:length(v_out)-5000);
% Offset abschneiden
v_out = v_out - mean(v_out);
% Normalisieren
v_out_max = max(abs(v_out));
v_out = v_out./v_out_max;
% Zurückgewonnenes Signal abspeichern
audiowrite('/home/chi/Demo/AK2_FM_Modulation/audio/mozart_orig.wav',v_out,fs);

%% Spektrum berechnen (danach)
uspec = fft(v_out);         % berechne Fast Fourier Transform (= digitale Form der Fourier-Transformation) von Signal u
N = length(uspec);      % bestimme Anzahl von Elementen in Spektrumvektor = Anzahl von Samples in u

umagspec = abs(uspec);               % bestimme Betragsspektrum

umagspec = 2/N*umagspec(1:N/2);     % bestimme einseitiges (d.h., nur positive Frequenzen) Betragsspektrum
                                          % und skaliere (Faktor 2/N) auf physikalische Amplitudenwerte

umagspec(1) = umagspec(1)/2;        % korrigiere Gleichanteil

Df = fs/N;          % Frequenzauflösung
f = 0:Df:(N-1)*Df;  % Beschriftung der Frequenzachse
f = f(1:N/2);       % entferne negativen Frequenzanteil

figure(3)
stem(f,umagspec)
grid on
