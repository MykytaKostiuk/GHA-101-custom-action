KEYWORD=FIXED

run: build
	docker run --rm keyword-release-action $(KEYWORD)

build:
	docker build -t keyword-release-action .

test: 
	./entrypoint.sh $(KEYWORD)