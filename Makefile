NAME=smart_contract

all: build deploy interact

build:
	docker build -t $(NAME) .
	docker run -d --name $(NAME) -p 8545:8545 $(NAME)

start:
	docker start $(NAME)

compile:
	docker exec $(NAME) npx hardhat compile

deploy:
	docker exec $(NAME) npx hardhat run scripts/deploy.js --network localhost

interact:
	docker exec $(NAME) npx hardhat run scripts/interactWithContract.js --network localhost

stop:
	docker stop $(NAME)

clean: stop
	docker rm $(NAME)

fclean: 
	docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null

re: fclean all

.PHONY: build start compile deploy interact stop clean fclean re all