build: clean
	@echo "====== RUN postgres ======"
	docker-compose up --build -d

clean:
	docker-compose stop || true
