package main

import (
	"context"
	"log"
	"time"

	pb "github.com/yankay/golang-helloworld-api/helloworld"
	"google.golang.org/grpc"
	"google.golang.org/protobuf/types/known/emptypb"
)

func Ping() {
	conn, _ := grpc.Dial(":8080", grpc.WithInsecure())
	c := pb.NewHelloworldClient(conn)
	ctx, client := context.WithTimeout(context.Background(), time.Second)
	defer client()
	// Contact the server and print out its response.
	r, _ := c.Ping(ctx, &emptypb.Empty{})
	log.Printf("Ping Sucess: %s", r.GetMessage())

}

func main() {
	Ping()
}
