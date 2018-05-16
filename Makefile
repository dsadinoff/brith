#dots
#PASSAGE=Deuteronomy.29.28

#PASSAGE=Exodus.10.1-11
PASSAGE=Exodus.10.12-23
# S2B=./sefaria2braille -e $(ENCODING)
FETCH=./fetchSefaria

PFILE = tmp/$(PFILE_BASE)
PFILE_BASE = $(PASSAGE).utf8
BRF_FILE = $(PASSAGE).$(ENCODING).$(DAGESHMODE).brf

PANGRAM_FILE = pangram.ashkenaz.$(ENCODING).$(DAGESHMODE)
PANGRAM_FILE_BRF =  $(PANGRAM_FILE).brf
ENCODE=./encodeHebrew -e $(ENCODING) -m $(DAGESHMODE)
ENCODING=CP
DAGESHMODE=HEH_BCFT

#OUTPUTS += out5.$(ENCODING).html
OUTPUTS += tmp/$(PASSAGE).$(ENCODING).$(DAGESHMODE).html
OUTPUTS += tmp/$(BRF_FILE)
OUTPUTS += tmp/pangram.ashkenaz.$(ENCODING).$(DAGESHMODE).html
OUTPUTS += tmp/pangram.ashkenaz.$(ENCODING).$(DAGESHMODE).brf
OUTPUTS += tmp/summary.$(ENCODING).$(DAGESHMODE).html

$(PFILE) :
	$(FETCH) $(PASSAGE) > $@.tmp
	mv $@.tmp $@

tmp/$(BRF_FILE): $(PFILE)
	$(ENCODE) -a $(PFILE) > $@.tmp
	mv $@.tmp $@



tmp/$(PASSAGE).$(ENCODING).$(DAGESHMODE).html: $(PFILE)
	cat pre1.html  > $@.tmp
	$(ENCODE) -w --add-word-ids $(PFILE) >> $@.tmp
	echo "<td >" >> $@.tmp
	$(ENCODE) --add-space -u --highlight-taamim --add-word-ids $(PFILE) >> $@.tmp

	(echo "<br><a href='$(BRF_FILE)' >Download BRF</a></div></td>" ) >> $@.tmp
	# echo "<tr><td><pre>" >> $@.tmp
	# oduni -h -s  $(PFILE) >> $@.tmp
	# echo "</pre><td><pre>" >> $@.tmp
	# $(ENCODE)  -u $(PFILE)|perl  -CS -lpe 's//\n/g'	 >> $@.tmp
	# echo "</pre></td>" >> $@.tmp
	echo "</table>" >> $@.tmp
	cat post-script.html  >> $@.tmp
	mv $@.tmp $@



tmp/$(PANGRAM_FILE_BRF): pangram.ashkenaz
	$(ENCODE) -a $< > $@.tmp
	mv $@.tmp $@


tmp/pangram.ashkenaz.$(ENCODING).$(DAGESHMODE).html: pangram.ashkenaz
	cat pre1.html  > $@.tmp
	$(ENCODE) -w --add-word-ids  $<  >> $@.tmp
	echo "<td>" >> $@.tmp
	$(ENCODE) --add-word-ids --add-space -u --highlight-taamim $< >> $@.tmp


	(echo "<br><a href='$(PANGRAM_FILE_BRF)' >Download BRF</a></div></td>" ) >> $@.tmp
	# echo "<tr><td><pre>" >> $@.tmp
	# oduni -h -s $< >> $@.tmp
	# echo "</pre><td><pre>" >> $@.tmp
	# $(ENCODE) -u $<|perl  -CS -lpe 's//\n/g'	 >> $@.tmp
	# echo "</pre></td>" >> $@.tmp
	echo "</table>" >> $@.tmp

	cat post-script.html  >> $@.tmp
	mv $@.tmp $@


tmp/summary.$(ENCODING).$(DAGESHMODE).html: tester.pl
	./tester.pl -m $(DAGESHMODE)  -e $(ENCODING) > $@.tmp;
	mv $@.tmp $@


push: $(OUTPUTS)
	cp $(OUTPUTS) docs
	cp $(OUTPUTS) ~dsadinoff/www/tmp


clean:
	-rm  $(OUTPUTS)


all:
	$(MAKE)  clean push ENCODING=CO
	$(MAKE) clean push ENCODING=CP
