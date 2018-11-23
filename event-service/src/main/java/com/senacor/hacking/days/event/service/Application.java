package com.senacor.hacking.days.event.service;

import com.senacor.hacking.days.event.service.handler.EventHandler;
import com.senacor.hacking.days.event.service.handler.MemberHandler;
import com.senacor.hacking.days.event.service.handler.UserHandler;
import com.senacor.hacking.days.event.service.repository.EventRepository;
import com.senacor.hacking.days.event.service.repository.UserRepository;
import com.senacor.hacking.days.event.service.repository.MongoDB;
import com.senacor.hacking.days.event.service.service.EventService;
import com.senacor.hacking.days.event.service.service.MemberService;
import com.senacor.hacking.days.event.service.service.UserService;
import io.helidon.webserver.Routing;
import io.helidon.webserver.ServerConfiguration;
import io.helidon.webserver.WebServer;
import lombok.Getter;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

@Getter
public class Application {

    private final MongoDB mongoDB;
    private final EventService eventService;
    private final MemberService memberService;
    private final UserService userService;
    private final EventHandler eventHandler;
    private final MemberHandler memberHandler;
    private final UserHandler userHandler;
    private final UserRepository userRepository;
    private final EventRepository eventRepository;

    private WebServer webServer;

    Application() {
        mongoDB = new MongoDB();
        eventRepository = new EventRepository(mongoDB);
        userRepository = new UserRepository(mongoDB);
        eventService = new EventService(eventRepository);
        memberService = new MemberService(userRepository);
        userService = new UserService(userRepository);
        eventHandler = new EventHandler(eventService);
        memberHandler = new MemberHandler(memberService);
        userHandler = new UserHandler(userService);
    }

    private Routing createRouting() {
        return Routing.builder()
                .register("/event", eventHandler)
                .register("/event/{eventId}/member", memberHandler)
                .register("/user", userHandler)
                .build();
    }

    void startServer() throws InterruptedException, ExecutionException, TimeoutException {
        ServerConfiguration configuration = ServerConfiguration.builder()
                .port(10000)
                .build();

        webServer = WebServer
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

    public static void main(String[] args) throws InterruptedException, ExecutionException, TimeoutException {
        new Application().startServer();
    }
}
