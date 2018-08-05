Il file ./liquid_state_machine.m contiene l'implementazione di Izhikevich della LSM (modificata per questo assignment).

Il file ./valve.m esegue la model selection e salva i parametri selezionati.

Il file ./pplot.m calcola l'errore in TR e TS del modello con i parametri finali.

I valori selezionati dalla model selection non sono molto stabili, ma in genere sembra che selezioni solo valori piccoli, Ne <= 20 e Ni <= 20.
Al momento i parametri salvati nei file .mat sono Ne=10 e Ni=5.
L'errore finale con i parametri salvati è:
- (TR+VAL): 33.8
- (TS): 31.3
e in generale rimane su questi valori anche per gli altri parameteri selezionati. 