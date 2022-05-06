# FM-Modulation/Demodulation

Das Ziel der Übung ist ein Musikstück auf ein Sinussignal modulieren und dann dieses Signal demodulieren (zurückgewinnen).

### Theorie:
FM is eine Form der Modulation dei der, die Frequenzänderungen am Trägersignal entsprechen der Änderungen am Basisbandsignal. Die Amplitude des Signals bleibt dabei konstant. FM ist eine analoge Form der Signalübertragung.

![FM-Modulation](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/img/frequencymodulation.png?raw=true "FM-Modulation")
<br /> Wie der Name schon sagt ist FM in Radioübertragung andewendet. Die andere Anwendungsbereiche sind: Radaren, seismische Erkundung, Telemetrie, Magnetbandaufzeichnung u.s.w.

### Rahmenbedinungen:

- Es gibt insgesamt zwei Matlab-Skripten: ein Skript für Modulation und einen Zweiten um das Signal zurückgewinnen.
- [FM-Modulation.m](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/FM-Modulation.m/) führt die FM-Modulation aus und deswegen muss er zuerst ausgefüht sein. Der Signal wird in Audiodatei ([mozart_fm.wav](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/audio/mozart_fm.wav/)) abgespeichert.
- [FM-Demodulation.m](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/FM-Demodulation.m/) demoduliert diesen Signal bzw. gewinnt ihn wieder und speichert ihn als [mozart_orig.wav](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/audio/mozart_orig.wav/) Datei ab.

### **FM-Modulation**

**STEP 1**<br />
Denn wir in MATLAB nur mit diskrete Signale arbeiten können muss unsere Audiodatei zuerst abgetastet werden.

<pre><code>[v_in, fs] = audioread('./AK2_FM_Modulation/audio/mozart.wav');</code></pre>

**STEP 2**<br />
Butterworth Filter Entwurf. Der Basissignal muss von Frequnzen, die für das menschliche Ohr unrelevent sind gefiltert werden.
<br /> ![Butterworth Filter](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/img/butter_filter.jpg?raw=true "Butterworth Filter")
<pre><code>[N,Wn] = buttord(2*fpass/fs, 2*fstop/fs,apass,astop);<br />[B,A] = butter(N,Wn);</code></pre><br />

**STEP 3**<br />
Wie wir schon wissen die Formel für die Frequenzmodulation lautet:

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}u_{FM}(t)=sin(\varphi&space;(t)))">
</p>

Daher berechnen wir die Phase
&nbsp;<img src="https://latex.codecogs.com/png.image?\dpi{110}&space;\varphi(t)">
. Die Phase ergibt sich aus folgenden Beziehungen:

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}\varphi&space;(t)&space;=&space;\omega_{0}&space;t&space;&plus;&space;\varphi_{0}&space;">
</p>

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}\omega(t)=\frac{\mathrm{d}&space;\varphi&space;(t)}{\mathrm{d}&space;t}&space;=&space;Ks(t)&plus;\omega_{T}">
</p>

<p align="center">
wobei für &nbsp;
<img src="https://latex.codecogs.com/png.image?\dpi{110}|s(t)|\leqslant&space;1"> &nbsp;
gilt: &nbsp; 
<img src="https://latex.codecogs.com/png.image?\dpi{110}K<s(t)">
</p>

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}\omega(t)\mathrm{d}t=\mathrm{d}&space;\varphi&space;(t)&space;&space;|&space;\int">
</p>

Aus den letzten zwei Gleichungen lässt sich die Phase &nbsp;
<img src="https://latex.codecogs.com/png.image?\dpi{110}\varphi&space;(t)"> &nbsp; ausrechnen.

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}\varphi&space;(t)&space;=&space;\int_{-\infty}^{t}&space;\omega(\tau&space;){\mathrm{d}&space;\tau}&space;=&space;K\int_{-\infty}^{t}&space;s(\tau&space;){\mathrm{d}&space;\tau+\omega_{T}t}">
</p>


Wiederholen wir gleichen Vorgang im Matlab. Diese Matlab befehle geben den Wert von 
&nbsp;
<img src="https://latex.codecogs.com/png.image?\dpi{110}\varphi&space;(t)"> &nbsp;
aus und schneiden die
&nbsp;
<img src="https://latex.codecogs.com/png.image?\dpi{110}2\pi&space;"> &nbsp;
Anteile ab.


<pre><code>phi(1) = K*v_out(1)*Ts + wt*Ts;<br />phi(1) = mod(phi(1),2*pi);<br />for i=2:1:N   
    phi(i) = phi(i-1) + K*v_out(i)*Ts + wt*Ts;
    phi(i) = mod(phi(i),2*pi);    
end</code></pre><br />

**STEP 4** <br />
Am Schluss modulieren wir das Signal, das gesendet werden muss, auf Trägersignal und speichern ihn als [mozart_fm.wav](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/mozart_fm.wav/) Datei ab.
<pre><code>v_fm = sin(phi)
audiowrite('mozart_fm.wav',v_fm,fs);</code></pre>
Wenn wir das FM-Signal Plotten bekommen wir folgenden Graph:
<br /> ![FM-Modulation](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/img/fm_and_audio.jpg?raw=true "FM-Modulation")
<br /><br />
### **FM-Demodulation**
**STEP 1** <br />
Denn Matlab nur mit diskreten Werte arbeiten kann, wird zuerst das FM-Signal abgetastet, so bekommt man diskrete Werte und Samplingrate.
<pre><code>[v_in, fs] = audioread('./AK2_FM_Modulation/audio/mozart_fm.wav');</code></pre>
Im nächsten Schritt muss das wert-diskrete Signal differenziert werden. Somit wird das FM-moduliertes Signal in das AM-Moduliertes Signal umgewandelt.

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}\frac{\mathrm{d}u_{FM}(t)&space;}{\mathrm{d}&space;x}=cos(\varphi(t))\times&space;(Ks(t)&plus;\omega_{T})">
</p>

<pre><code>v_diff = diff(v_in);</code></pre>

**STEP 2**<br />
Um das übertragene Signal zurückgewinnen, wenden wir das Hilbert Transformation an.

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}H[y(t)]=y(t)\ast&space;\frac{1}{\pi&space;t}">
</p>

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}H[y(t)]=&space;\frac{1}{\pi}&space;\int_{-\infty}^{\infty&space;}&space;\frac{y(\tau)}{t-\tau}\mathrm{d}\tau">
</p>

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}H[y(t)]=&space;\frac{1}{\pi}&space;\int_{-\infty}^{\infty&space;}&space;\frac{y(t-\tau)}{\tau}\mathrm{d}\tau">
</p>

Der Hilbert Transformator lässt sich aus Verhältniss von Eingangssignal zum Ausgangssignal berechnen.

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}H_{H}(j\omega&space;)=\frac{\hat{z}(j\omega)}{\hat{y}(j\omega)}&space;=&space;-jsign(\omega&space;)">
</p>

Der Impulsantwort des LTI-Systems ist eine inverse FFT des Hilbett-Transformators.

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}h_{H}(t&space;)=&space;F^{-1}\left\{&space;H_{H}(j\omega)&space;\right\}=\frac{1}{\pi&space;t}">
</p>


Eine einfache (kausale) zeitdiskrete Realisierung eines Hilbert-Transformators erhält man mittels der Fenster-Methode als FIR-Filter der ungeraden Ordnung
&nbsp;<img src="https://latex.codecogs.com/png.image?\dpi{110}M">&nbsp;
durch Abtastung der zeitbegrenzten und zeitverschobenen Impulsantwort
&nbsp;<img src="https://latex.codecogs.com/png.image?\dpi{110}h_{H}(t)">&nbsp;
des idealen Hilbert-Transformators mit Abtastperiode
&nbsp;<img src="https://latex.codecogs.com/png.image?\dpi{110}T_{s}">&nbsp;
zu.

<pre><code>for i=1:1:M+1
    hilb_filter_coeff(i) = 1/(pi*(i-M/2-1));
end
hilb_imag = filter(hilb_filter_coeff,1,v_diff);</code></pre>

**STEP 3** <br />
Ein sogenanntes analytisches Signal
&nbsp;<img src="https://latex.codecogs.com/png.image?\dpi{110}y^{+}(t)">&nbsp;
weist Spektralkomponenten nur bei positiven Frequenzen auf. Man gewinnt aus einem allgemeinen reellen Signal 
&nbsp;<img src="https://latex.codecogs.com/png.image?\dpi{110}y^{+}(t)">&nbsp;
ein zugehöriges analytisches Signal
&nbsp;<img src="https://latex.codecogs.com/png.image?\dpi{110}y(t)">
.

<br /> ![Analytisches Signal](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/img/blockdiapram_analyt_sig.png?raw=true "Gewinnung des Analytischen Signals")

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}y^{&plus;}(t)=y(t)&plus;jH{y}(t)">
</p>

Aus diesem analytischen Signal
&nbsp;<img src="https://latex.codecogs.com/png.image?\dpi{110}y^{+}(t)">&nbsp;
kann nun die Amplitudeninformation
&nbsp;<img src="https://latex.codecogs.com/png.image?\dpi{110}x(t)">&nbsp;
extrachiert werden.

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}y^{&plus;}(t)=\frac{x(t)}{2}e^{j\omega_{0}t}&plus;\frac{x(t)}{2}e^{-j\omega_{0}t}\leftrightarrow&space;\hat{y}^{&plus;}(t)=\frac{1}{2}\hat{x}(j\omega-j\omega_{0})&plus;\frac{1}{2}\hat{x}(j\omega&plus;j\omega_{0})">
</p>

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}y^{&plus;}(t)=y(t)&plus;jH{y}(t)&space;\leftrightarrow&space;\hat{y}^{&plus;}(j\omega)=\hat{x}(j\omega-j\omega_{0})">
</p>

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}\hat{y}^{&plus;}(j\omega)=\hat{x}(j\omega-j\omega_{0})&space;\leftrightarrow&space;x(t)e^{j\omega_{0}t}&space;=&space;y^{&plus;}(t)">
</p>

<p align="center">
<img src="https://latex.codecogs.com/png.image?\dpi{110}\left|&space;y^{&plus;}(t)\right|&space;=&space;\left|&space;y(t)&plus;jH{y}(t)\right|&space;=&space;\sqrt{y^{2}(t)&plus;(H{y}(t))^{2}}&space;=&space;\left|&space;x(t)\right|">
</p>

In Matlab sind folgende Befehle ausgeführt:

<pre><code>v_diff = cat(1,zeros((M+1)/2,1),v_diff);
hilb_imag = cat(1,hilb_imag,zeros((M+1)/2,1));
v_hilb = v_diff + 1i*hilb_imag;
v_out = abs(v_hilb);</code></pre>

Auf diese Arten werden die negative Erequenzbereich abgechnitten und positive Bereich dagegen verstärkt.

Im Zeitbereich wird die Impulsantwort nach rechts "verschoben". So wird das Signal mit eine gewisse Verzögerung an Empfänger ankommen, aber die Verzögerung in Millisekundenbereich wird der Empfänger kaum merken. 

**STEP 4** <br />
Letzendlich muss das Signal von Trägersignal Frequenzen gefiltert werden. Das Signal wird mit Butterworth gefiltert.

<pre><code>apass = 1.;    % max. Dämpfung im Durchlassbereich
astop = 50;     % min. Dämpfung im Sperrbereich
fpass = 6e3;    % Durchlassgrenze
fstop = 8e3;    % Sperrgrenze

[N,Wn] = buttord(2*fpass/fs, 2*fstop/fs,apass,astop);
[B,A] = butter(N,Wn);
v_out = filter(B,A,v_out);</code></pre>
Da am Anfang und am Ende des zurückgewonnen Sigals rauschen vorkommen, waren diese Bereiche abgechnitten. Der Offset des Signals wird auch entfernt und das Signal selber entsprechend skaliert (normalisiert).

<br /> ![Störungen & Offset](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/img/stoer&offset.jpg?raw=true "Störungen & Offset")

<pre><code>v_out = v_out(5000:length(v_out)-5000);
v_out = v_out - mean(v_out);
v_out_max = max(abs(v_out));
v_out = v_out./v_out_max;</code></pre>

Das zurückgewonene Signal wird als [mozart_orig.wav](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/audio/mozart_orig.wav/) abgeschpeichert.

<pre><code>audiowrite('mozart_orig.wav',v_out,fs);</code></pre>

<br /> ![Vergleich](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/img/vor_FM.jpg?raw=true "Vergleich des Signals vor Modulation und nach Demodulation")
<br /> ![Vergleich](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/img/nach_Demod.jpg?raw=true "Vergleich des Signals vor Modulation und nach Demodulation")


