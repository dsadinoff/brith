#dots
#PASSAGE=Deuteronomy.29.28

PASSAGE=Exodus.10.1-11
# PASSAGE=Exodus.10.1-2
# S2B=./sefaria2braille -e $(ENCODING)
FETCH=./fetchSefaria

PFILE = $(PASSAGE).utf8
ENCODE=./encodeHebrew -e $(ENCODING)
ENCODING=CP

#OUTPUTS += out5.$(ENCODING).html
OUTPUTS += $(PASSAGE).$(ENCODING).html
OUTPUTS += pangram.ashkenaz.$(ENCODING).html
OUTPUTS += summary.$(ENCODING).html


$(PASSAGE).$(ENCODING).html:
	cat pre1.html  > $@.tmp
	$(FETCH) $(PASSAGE) > $(PFILE)
	cat $(PFILE) >> $@.tmp
	echo "<td>" >> $@.tmp
	$(ENCODE) -u --highlight-taamim $(PFILE) >> $@.tmp

	(echo "<br><a href='' id=downlink>Download BRF</a><pre id='brf-data' data-source-file-name='$@'>" && $(ENCODE) -a $(PFILE) | perl -lape';s{&}{&amp;}g;s{<}{&lt;}g;'  && echo "</pre></td>" ) >> $@.tmp



	echo "<tr><td><pre>" >> $@.tmp
	oduni -h -s  $(PFILE) >> $@.tmp
	echo "</pre><td><pre>" >> $@.tmp
	$(ENCODE) -u $(PFILE)|perl  -CS -lpe 's//\n/g'	 >> $@.tmp
	echo "</pre></td></table>" >> $@.tmp
	cat post-script.html  >> $@.tmp
	mv $@.tmp $@


# out5.$(ENCODING).html:
# 	cat pre1.html  > $@.tmp
# 	$(S2B) -w $(PASSAGE)  >> $@.tmp
# 	echo "<td>" >> $@.tmp
# 	$(S2B) -u --highlight-taamim $(PASSAGE) >> $@.tmp

# 	(echo "<br><a href='' id=downlink>Download BRF</a><pre id='brf-data' data-source-file-name='$@'>" && $(S2B) -a $(PASSAGE) | perl -lape';s{&}{&amp;}g;s{<}{&lt;}g;'  && echo "</pre></td>" ) >> $@.tmp



# 	echo "<tr><td><pre>" >> $@.tmp
# 	$(S2B) -w $(PASSAGE)|oduni -h -s  >> $@.tmp
# 	echo "</pre><td><pre>" >> $@.tmp
# 	$(S2B) -u $(PASSAGE)|perl  -CS -lpe 's//\n/g'	 >> $@.tmp
# 	echo "</pre></td></table>" >> $@.tmp
# 	cat post-script.html  >> $@.tmp
# 	mv $@.tmp $@

pangram.ashkenaz.$(ENCODING).html: pangram.ashkenaz
	cat pre1.html  > $@.tmp
	cat  $<  >> $@.tmp
	echo "<td>" >> $@.tmp
	$(ENCODE) -u --highlight-taamim $< >> $@.tmp

	(echo "<br><a href='' id=downlink>Download BRF</a><pre id='brf-data' data-source-file-name='$@'>" && $(ENCODE) -a  $< | perl -lape';s{&}{&amp;}g;s{<}{&lt;}g;'  && echo "</pre></td>" ) >> $@.tmp

	echo "<tr><td><pre>" >> $@.tmp
	oduni -h -s $< >> $@.tmp
	echo "</pre><td><pre>" >> $@.tmp
	$(ENCODE) -u $<|perl  -CS -lpe 's//\n/g'	 >> $@.tmp
	echo "</pre></td></table>" >> $@.tmp
	cat post-script.html  >> $@.tmp
	mv $@.tmp $@


summary.$(ENCODING).html: tester.pl
	./tester.pl  -e $(ENCODING) > $@.tmp;
	mv $@.tmp $@


push: $(OUTPUTS)
	cp $(OUTPUTS) docs
	cp $(OUTPUTS) ~dsadinoff/www/tmp


clean:
	-rm  $(OUTPUTS)
