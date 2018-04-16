PASSAGE=Exodus.10.1-11
# PASSAGE=Exodus.10.1-2
S2B=./sefaria2braille

out4.html:
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


testSheet.html: tester.pl
	./tester.pl > $@.tmp;
	mv $@.tmp $@


push: out4.html  testSheet.html
	cp testSheet.html out4.html docs
	cp testSheet.html out4.html ~dsadinoff/www/tmp


clean:
	-rm  out4.html testSheet.html
