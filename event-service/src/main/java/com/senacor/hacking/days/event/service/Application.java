package com.senacor.hacking.days.event.service;

import com.senacor.hacking.days.event.service.handler.EventService;
import io.helidon.webserver.Routing;
import io.helidon.webserver.ServerConfiguration;
import io.helidon.webserver.WebServer;

import java.net.UnknownHostException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class Application {

    private Routing createRouting() {
        return Routing.builder()
                .register("/event", new EventService())
                .build();
    }

    private void startServer() throws InterruptedException, ExecutionException, TimeoutException, UnknownHostException {
        ServerConfiguration configuration = ServerConfiguration.builder()
                .port(10000)
                .build();

        WebServer webServer = WebServer
                .create(configuration, createRouting())
                .start()
                .toCompletableFuture()
                .get(10, TimeUnit.SECONDS);

        // Start the server and print some info.
        webServer.start().thenAccept(ws -> System.out.println(
                "WEB server is up! " + ws.configuration().bindAddress() + ":" + ws.port()));

        // Server threads are not demon. NO need to block. Just react.
        webServer.whenShutdown().thenRun(()
                -> System.out.println("WEB server is DOWN. Good bye!"));
    }

    public static void main(String[] args) throws InterruptedException, ExecutionException, TimeoutException, UnknownHostException {
        new Application().startServer();
    }
}
