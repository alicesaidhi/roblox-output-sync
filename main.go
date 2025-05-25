package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/log", func(w http.ResponseWriter, r *http.Request) {
		io.WriteString(w, "posted")
		result, err := io.ReadAll(r.Body)

		if err != nil {
			fmt.Println(err.Error())
			return
		}

		fmt.Println(string(result))
	})

	fmt.Println("serving...")
	log.Fatal(http.ListenAndServe(":5642", nil))
}
