# Location of virtualenv used for development.
VENV?=../galaxy/.venv
IN_VENV=if [ -f $(VENV)/bin/activate ]; then . $(VENV)/bin/activate; fi;

generate-slides:
	rm docs/index.html
	echo "<html><head></head><body>" > docs/index.html
	$(IN_VENV) python slideshow/build_slideshow.py 'Tool Shed' intro/05-tool-shed/shed_intro.md 05-tool-shed
	$(IN_VENV) python slideshow/build_slideshow.py 'Tool Installation' intro/05-tool-shed/tool_installation.md 05-tool-shed
	$(IN_VENV) python slideshow/build_slideshow.py 'Galaxy Architecture' intro/12-architecture/galaxy_architecture.md 12-architecture
	echo "</body></html>" >> docs/index.html
