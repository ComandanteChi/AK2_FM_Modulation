# FM-Modulation/Demodulation

Das Ziel der Übung ist ein Musikstück auf ein Sinussignal aufmodulieren und dann demodulieren.
### Theorie:
FM is eine Form der Modulation dei der, die Frequenzänderungen am Trägersignal entsprechen der Änderungen am Basisbandsignal. Die Amplitude des Signals bleibt dabei konstant. FM ist eine analoge Form der Signalübertragung.

![FM-Modulation](https://github.com/ComandanteChi/AK2_FM_Modulation/blob/main/img/frequencymodulation.png)
<br /> Wie der Name schon sagt ist FM in Radioübertragung andewendet. 

### Rahmenbedinungen:
- ein Skript für Modulation und einen Zweiten um das Signal zurückgewinnen;
- 
### FM-Modulation
STEP 1 <br />
Denn wir in MATLAB nur mit diskrete Signale arbeiten können muss unsere Audiodatei zuerst abgetastet werden.

<pre><code>[v_in, fs] = audioread('./AK2_FM_Modulation/mozart_fm.wav');</code></pre>

STEP 2

