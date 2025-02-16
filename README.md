# eserver
eserver is a simple Elixir Restful Server with CowBoy and MongoDB  


# Environment
Install [Elixir](https://elixir-lang.org/install.html), [Docker Desktop](https://docs.docker.com/desktop/), [MongoDB](https://www.mongodb.com/docs/manual/installation/) with [mongodb_driver](https://github.com/zookzook/elixir-mongodb-driver) and [hexdocs mongodb](https://hexdocs.pm/mongodb_driver/Mongo.html).  



# Run project
```bash
# Start MongoDB.
## Start docker compose mongodb
docker compose up -d

## Stop docker compose mongodb
docker compose stop

## Stop & Remove container docker compose mongodb
docker compose down


# Create project
## flag --sup creates application with a supervision tree.
mix new eserver --sup

# Install dependencies
mix deps.get

# Run test
mix test

# Start server
iex -S mix run

#==> Open browse with URL: http://localhost:8080

## recompile dùng để build lại source code mới khi project vẫn đang chạy.
iex(1)> recompile

```

# Call API
## Add New Post
```bash
curl -X POST -i 'http://127.0.0.1:8080/post' \
  -H "Content-Type: application/json" \
  --data '{
    "name": "name1",
    "content": "content1"
  }'

{"content":"content1","id":"67b1d3c3f7de9f9a139ddcb8","name":"name1"}

{"content":"content2","id":"67b1d598f7de9f9a1373005e","name":"name2"}
```

## Get Post
```bash
# Get a post
curl -X GET -H 'Content-Type: application/json' \
  -i 'http://127.0.0.1:8080/post/67b1d3c3f7de9f9a139ddcb8'

# Get all posts
curl -X GET -H 'Content-Type: application/json' \
  -i 'http://127.0.0.1:8080/posts'
```

## Update Post
```bash
curl -X PUT -i 'http://127.0.0.1:8080/post/67b1d3c3f7de9f9a139ddcb8' \
  -H "Content-Type: application/json" \
  --data '{
    "name": "name1 update",
    "content": "content1 update"
  }'

{"content":"content1 update","id":"67b1d3c3f7de9f9a139ddcb8","name":"name1 update"}
```

## Delete Post
```bash
curl -X DELETE -H 'Content-Type: application/json' \
  -i 'http://127.0.0.1:8080/post/67b1d598f7de9f9a1373005e'

{"id":"67b1d598f7de9f9a1373005e"}
or
Not found
```



# Install Docker Desktop
Docker Desktop là đã bao gồm các thành phần như: Docker Engine, Docker CLI client, Docker Scout, Docker Build, Docker Extensions, Docker Compose, Docker Content Trust, Kubernetes, Credential Helper.  

1. Set up Docker's package repository. See step one of [Install using the apt repository](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository).  
```bash
# Setup on Ubuntu 16/02/2025
## https://docs.docker.com/desktop/setup/install/linux/ubuntu/
sudo apt install gnome-terminal

## Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

2. Download the latest [DEB package](https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb).  

3. Install the package with apt as follows:  
```bash
sudo apt-get update
sudo apt-get install ./docker-desktop-amd64.deb

#==> By default, Docker Desktop is installed at /opt/docker-desktop.
```

4. Launch Docker Desktop  
```bash
# open a terminal and run:
systemctl --user start docker-desktop
```

5. Check version
```bash
$ docker --version
Docker version 27.5.1, build 9f9e405

$ docker compose version
Docker Compose version v2.32.4-desktop.1

$ docker version
Client: Docker Engine - Community
 Version:           27.5.1
 API version:       1.47
 Go version:        go1.22.11
 Git commit:        9f9e405
 Built:             Wed Jan 22 13:41:31 2025
 OS/Arch:           linux/amd64
 Context:           desktop-linux

Server: Docker Desktop 4.38.0 (181591)
 Engine:
  Version:          27.5.1
  API version:      1.47 (minimum version 1.24)
  Go version:       go1.22.11
  Git commit:       4c9b3b0
  Built:            Wed Jan 22 13:41:17 2025
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.7.25
  GitCommit:        bcc810d6b9066471b0b6fa75f557a15a1cbf31bb
 runc:
  Version:          1.1.12
  GitCommit:        v1.1.12-0-g51d5e946
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```

6. Upgrade Docker Desktop  
Chỉ cần tải lại version mới rồi chạy lệnh cài đặt lại:  
```bash
sudo apt-get install ./docker-desktop-amd64.deb
```

7. Thêm thư mục /data vào File Sharing trên Tool Docker Desktop.  
```bash
Error response from daemon: Mounts denied:  
The path /data/docker/db is not shared from the host and is not known to Docker.  
You can configure shared paths from Docker -> Preferences... -> Resources -> File Sharing.  
See https://docs.docker.com/ for more info.  
```



**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `eserver` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:eserver, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/eserver>.

