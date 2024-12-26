# Beego Golang Project: Cat API Integration

This project is a Beego-based Golang application that interacts with [TheCatAPI](https://thecatapi.com/). The application allows fetching cat images, managing liked images, and handling votes.

## Features

- Fetch cat images from TheCatAPI
- Like and Dislike favorite cat images
- favourtie functionality for cat images



## Prerequisites

- **Install Go**: Ensure Go is installed on your system. [Download Go](https://golang.org/dl/).

## Setup Instructions

### Step 1: Configure Environment

#### For Linux and macOS
1. Open a terminal.
2. Edit your shell configuration file:
    - For bash:
      ```bash
      nano ~/.bashrc
      ```
    - For zsh:
      ```bash
      nano ~/.zshrc
      ```
3. Add the following lines to set `GOPATH` and update `PATH`:
    ```bash
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    ```
4. Save the file and reload your shell:
    ```bash
    source ~/.bashrc   # or ~/.zshrc
    ```
5. Verify the setup:
    ```bash
    echo $GOPATH
    echo $PATH
    ```

#### For Windows
1. Set up the Go environment variables:
    - `GOPATH`: Your workspace directory.
    - `PATH`: Add `$GOPATH/bin` to your `PATH`.

### Step 2: Initialize the Project in the specific directory ( Home)

1. Create a new directory in the Home (a folder named "go") for the project :
   - open terminal in the go folder
    ```bash
    mkdir src
    cd src
    go mod init src
    ```

### Step 3: Install Beego

Install Beego using the following command:
```bash
go get github.com/beego/beego/v2
```

### Step 4: Install Bee CLI (Recommended)

1. Install Bee CLI to manage Beego projects:
    ```bash
    go install github.com/beego/bee/v2@latest
    ```
2. Verify the Bee CLI installation:
    ```bash
    bee version
    ```

### Step 5: Create and Setup the Project

1. Use Bee CLI to create a new Beego project:
    ```bash
    bee new my-beego-app
    cd my-beego-app
    ```

2. Clone the project repository into this directory:
    ```bash
    git clone https://github.com/Mahi-markus/Cat_API_golang-beego-.git
    ```

### Step 6: Run the Project

1. Start the application:
    ```bash
    cd Cat_API_golang-beego-
    go mod tidy
    bee run
    ```
2. Open the application in your browser:
    [http://localhost:8080](http://localhost:8080)

## Testing

To test the application, open another terminal inside the "Cat_API_golang-beego-" folder and run the following commands:

1. Run all tests:
    ```bash
    go test ./tests -v
    ```

2. Check test coverage:
    ```bash
    go test -coverprofile coverage.out ./...
    go tool cover -html coverage.out
    ```

**after  this below command:**
```bash
go tool cover -html coverage.out
```

**you will show a html file if it does any problem in mozila (file not found)**
just copy the url and paste it in the chrome , you will see the coverage.
the test coverage will vary for each controller.


**special instruction**
- if the dropdown for breed doesnt show any breeds name, just click another time and you will see the breeds name properly.