
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


![equation](http://www.sciweavers.org/tex2img.php?eq=1%2Bsin%28mc%5E2%29&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=)


<p align="center">
<img src="https://render.githubusercontent.com/render/math?math=u_{FM}(t)=sin(\varphi (t))">
</p>

Daher berechnen wir die Phase $\varphi (t)$. Die Phase ergibt sich aus folgenden Beziehungen:

<p align="center">
<img src="https://render.githubusercontent.com/render/math?math=\varphi (t) = \omega_{0}t + \varphi_{0}">
</p>

$$
    \varphi (t) = \omega_{0} t + \varphi_{0}
$$
 
$$
  \omega(t)=\frac{\mathrm{d} \varphi (t)}{\mathrm{d} t} = Ks(t)+\omega_{T}
$$


<!-- $$
  \omega(t)=\frac{\mathrm{d} \varphi (t)}{\mathrm{d} t} = Ks(t)+\omega_{T}
$$ --> 

<div align="center"><img style="background: white;" src="https://render.githubusercontent.com/render/math?math=%20%20%5Comega(t)%3D%5Cfrac%7B%5Cmathrm%7Bd%7D%20%5Cvarphi%20(t)%7D%7B%5Cmathrm%7Bd%7D%20t%7D%20%3D%20Ks(t)%2B%5Comega_%7BT%7D"></div>



wobei für $|s(t)|\leqslant 1$ &nbsp; gilt: &nbsp; $K<s(t)$ 
$$
  \omega(t)\mathrm{d}t=\mathrm{d} \varphi (t)  | \int
$$

Aus den letzten zwei Gleichungen lässt sich die Phase $\varphi (t)$ ausrechnen.

$$
  \varphi (t) = \int_{-\infty}^{t} \omega(\tau ){\mathrm{d} \tau} = K\int_{-\infty}^{t} s(\tau ){\mathrm{d} \tau+\omega_{T}t}
$$

Wiederholen wir gleichen Vorgang im Matlab. Diese Matlab befehle geben den Wert von $\varphi (t)$ aus und schneiden die $2\pi$ Anteile ab.
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
$$
    \frac{\mathrm{d}u_{FM}(t) }{\mathrm{d} x}=cos(\varphi(t))\times (Ks(t)+\omega_{T})
$$

<pre><code>v_diff = diff(v_in);</code></pre>

**STEP 2**<br />
Um das übertragene Signal zurückgewinnen, wenden wir das Hilbert Transformation an.
$$
H[y(t)]=y(t)\ast \frac{1}{\pi t}
$$
$$
    H[y(t)]= \frac{1}{\pi} \int_{-\infty}^{\infty } \frac{y(\tau)}{t-\tau}\mathrm{d}\tau
$$
$$
    H[y(t)]= \frac{1}{\pi} \int_{-\infty}^{\infty } \frac{y(t-\tau)}{\tau}\mathrm{d}\tau
$$
Der Hilbert Transformator lässt sich aus Verhältniss von Eingangssignal zum Ausgangssignal berechnen.
$$

$$
Der Impullsantwort des LTI-Systems ist eine inverse FFT des Hilbett-Transformators.
$$

$$

Eine einfache (kausale) zeitdiskrete Realisierung eines Hilbert-Transformators erhält man mittels der Fenster-Methode als FIR-Filter der ungeraden Ordnung $M$ durch Abtastung der zeitbegrenzten und zeitverschobenen Impulsantwort $h_{H}(t)$ des idealen Hilbert-Transformators mit Abtastperiode $T_{s}$ zu.

<pre><code>for i=1:1:M+1
    hilb_filter_coeff(i) = 1/(pi*(i-M/2-1));
end
hilb_imag = filter(hilb_filter_coeff,1,v_diff);</code></pre>

**STEP 3** <br />
Ein sogenanntes analytisches Signal $y^{+}(t)$ weist Spektralkomponenten nur bei positiven Frequenzen auf. Man gewinnt aus einem allgemeinen reellen Signal $y^{+}(t)$ ein zugehöriges analytisches Signal $y(t)$.

<br /> ![Analytisches Signal](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/img/blockdiapram_analyt_sig.png?raw=true "Gewinnung des Analytischen Signals")
$$
    y^{+}(t)=y(t)+jH{y}(t)
$$
Aus diesem analytischen Signal $y^{+}(t)$ kann nun die Amplitudeninformation $x(t)$ extrachiert werden.
$$
    y^{+}(t)=\frac{x(t)}{2}e^{j\omega_{0}t}+\frac{x(t)}{2}e^{-j\omega_{0}t}\leftrightarrow \hat{y}^{+}(t)=\frac{1}{2}\hat{x}(j\omega-j\omega_{0})+\frac{1}{2}\hat{x}(j\omega+j\omega_{0})
$$
$$
    y^{+}(t)=y(t)+jH{y}(t) \leftrightarrow \hat{y}^{+}(j\omega)=\hat{x}(j\omega-j\omega_{0})
$$
$$
    \hat{y}^{+}(j\omega)=\hat{x}(j\omega-j\omega_{0}) \leftrightarrow x(t)e^{j\omega_{0}t} = y^{+}(t)
$$
$$
    \left| y^{+}(t)\right| = \left| y(t)+jH{y}(t)\right| = \sqrt{y^{2}(t)+(H{y}(t))^{2}} = \left| x(t)\right|
$$
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


