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
import io.helidon.security.Security;
import io.helidon.security.SubjectType;
import io.helidon.security.provider.httpauth.HttpBasicAuthProvider;
import io.helidon.security.provider.httpauth.UserStore;
import io.helidon.security.webserver.WebSecurity;
import io.helidon.webserver.Routing;
import io.helidon.webserver.ServerConfiguration;
import io.helidon.webserver.WebServer;
import io.helidon.webserver.json.JsonSupport;
import lombok.Getter;

import javax.json.Json;
import java.util.Optional;
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
                .register(WebSecurity.from(Security.builder()
                        .addAuthenticationProvider(this::createSecurity)
                        .build()).securityDefaults(WebSecurity.allowAnonymous()))
                .register(JsonSupport.get())
                .error(Exception.class, (req, res, ex) -> {
                    ex.printStackTrace();
                    res.status(400).send(Json.createObjectBuilder()
                            .add("Fehler", ex.getMessage()).build());
                })
                .register("/event", eventHandler)
                .register("/event/{eventId}/member", memberHandler)
                .register("/user", userHandler)
                .build();
    }

    private HttpBasicAuthProvider createSecurity() {
        return HttpBasicAuthProvider.builder()
                .realm("helidon")
                .subjectType(SubjectType.SERVICE)
                .userStore(login -> Optional.of(new UserStore.User() {
                    @Override
                    public String getLogin() {
                        return "Test";
                    }

                    @Override
                    public char[] getPassword() {
                        return "Test".toCharArray();
                    }
                }))
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
