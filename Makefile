PASSAGE=Exodus.10.1-11
# PASSAGE=Exodus.10.1-2
S2B=./sefaria2braille -e $(ENCODING)
ENCODING=CO

OUTPUTS += out4.$(ENCODING).html
OUTPUTS += pangram.ashkenaz.$(ENCODING).html
OUTPUTS += summary.$(ENCODING).html

out4.$(ENCODING).html:
	cat pre1.html  > $@.tmp
	$(S2B) -w $(PASSAGE)  >> $@.tmp
	echo "<td>" >> $@.tmp
	$(S2B) -u --highlight-taamim $(PASSAGE) >> $@.tmp

	(echo "<br><pre>" && $(S2B) -a $(PASSAGE) | perl -lape';s{&}{&amp;}g;s{<}{&lt;}g;'  && echo "</pre></td>" ) >> $@.tmp

	echo "<tr><td><pre>" >> $@.tmp
	$(S2B) -w $(PASSAGE)|oduni -h -s  >> $@.tmp
	echo "</pre><td><pre>" >> $@.tmp
	$(S2B) -u $(PASSAGE)|perl  -CS -lpe 's//\n/g'	 >> $@.tmp
	echo "</pre><td><pre>" >> $@.tmp
	mv $@.tmp $@

pangram.ashkenaz.$(ENCODING).html: pangram.ashkenaz
	cat pre1.html  > $@.tmp
	$(S2B) -s -w < $<  >> $@.tmp
	echo "<td>" >> $@.tmp
	$(S2B) -s -u --highlight-taamim < $< >> $@.tmp

	(echo "<br><pre>" && $(S2B) -a -s < $< | perl -lape';s{&}{&amp;}g;s{<}{&lt;}g;'  && echo "</pre></td>" ) >> $@.tmp

	echo "<tr><td><pre>" >> $@.tmp
	$(S2B) -w -s  < $< |oduni -h -s  >> $@.tmp
	echo "</pre><td><pre>" >> $@.tmp
	$(S2B) -u -s < $<|perl  -CS -lpe 's//\n/g'	 >> $@.tmp
	echo "</pre><td><pre>" >> $@.tmp
	mv $@.tmp $@


summary.$(ENCODING).html: tester.pl
	./tester.pl  -e $(ENCODING) > $@.tmp;
	mv $@.tmp $@


push: $(OUTPUTS)
	cp $(OUTPUTS) docs
	cp $(OUTPUTS) ~dsadinoff/www/tmp


clean:
	-rm  $(OUTPUTS)
