out4.html:
	cat pre1.html  > $@.tmp
	./heb2braille -w  >> $@.tmp
	echo "<td>" >> $@.tmp
	./heb2braille -u --highlight-taamim >> $@.tmp

	(echo "<br><pre>" && ./heb2braille -a | perl -lape';s{&}{&amp;}g;s{<}{&lt;}g;'  && echo "</pre></td>" ) >> $@.tmp

	echo "<tr><td><pre>" >> $@.tmp
	./heb2braille -w|oduni -h -s  >> $@.tmp
	echo "</pre><td><pre>" >> $@.tmp
	./heb2braille -u|perl  -CS -lpe 's//\n/g'	 >> $@.tmp
	echo "</pre><td><pre>" >> $@.tmp
	mv $@.tmp $@


testSheet.html: tester.pl
	./tester.pl > $@.tmp;
	mv $@.tmp $@


push: out4.html  testSheet.html
	cp testSheet.html out4.html docs


clean:
	-rm  out4.html testSheet.html
