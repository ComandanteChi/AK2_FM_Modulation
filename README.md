# FM-Modulation/Demodulation

Das Ziel der Übung ist ein Musikstück auf ein Sinussignal aufmodulieren und dann demodulieren.
### Theorie:
FM is eine Form der Modulation dei der, die Frequenzänderungen am Trägersignal entsprechen der Änderungen am Basisbandsignal. Die Amplitude des Signals bleibt dabei konstant. FM ist eine analoge Form der Signalübertragung.

![FM-Modulation](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/img/frequencymodulation.png?raw=true "FM-Modulation")
<br /> Wie der Name schon sagt ist FM in Radioübertragung andewendet. 

### Rahmenbedinungen:
- Es gibt insgesamt zwei Matlab-Skripten: ein Skript für Modulation und einen Zweiten um das Signal zurückgewinnen.
- [FM_Skript.m](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/FM_Skript.m/) führt die FM-Modulation aus und deswegen muss er zuerst ausgefüht sein. Der Signal wird in Audiodatei ([mozart_fm.wav](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/mozart_fm.wav/)) abgespeichert.
- [FM_Skript_2.m](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/FM_Skript_2.m/) demoduliert diesen Signal bzw. gewinnt ihn wieder und speichert ihn als [mozart_orig.wav](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/mozart_orig.wav/) Datei ab.

### FM-Modulation
STEP 1<br />
Denn wir in MATLAB nur mit diskrete Signale arbeiten können muss unsere Audiodatei zuerst abgetastet werden.

<pre><code>[v_in, fs] = audioread('./AK2_FM_Modulation/mozart.wav');</code></pre>

STEP 2<br />
Butterworth Filter Entwurf.
<br /> ![Butterworth Filter](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/img/butter_filter.jpg?raw=true "Butterworth Filter")
