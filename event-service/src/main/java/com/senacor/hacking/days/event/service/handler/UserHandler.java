package com.senacor.hacking.days.event.service.handler;

import com.senacor.hacking.days.event.service.handler.port.User;
import com.senacor.hacking.days.event.service.handler.port.UserList;
import com.senacor.hacking.days.event.service.service.UserService;
import io.helidon.webserver.Handler;
import io.helidon.webserver.Routing;
import io.helidon.webserver.ServerRequest;
import io.helidon.webserver.ServerResponse;
import io.helidon.webserver.Service;
import io.helidon.webserver.json.JsonSupport;
import lombok.AllArgsConstructor;

import javax.json.JsonObject;
import java.util.UUID;

@AllArgsConstructor
public class UserHandler implements Service {

    private final UserService userService;

    @Override
    public void update(Routing.Rules rules) {
        rules
                .register(JsonSupport.get())
                .delete("/{id}", this::deleteUser)
                .get("/", this::getAllUser)
                .post("/", Handler.of(JsonObject.class, this::createUser))
                .get("/{id}", this::getUser)
                .put("/{id}", Handler.of(JsonObject.class, this::updateUser));
    }

    void deleteUser(ServerRequest serverRequest, ServerResponse serverResponse) {
        String id = serverRequest.path().param("id");
        userService.deleteUser(UUID.fromString(id));
        serverResponse.status(204).send();
    }

    void updateUser(ServerRequest serverRequest, ServerResponse serverResponse, JsonObject input) {
        String id = serverRequest.path().param("id");
        User event = userService.updateUser(UUID.fromString(id), User.toUser(input));
        serverResponse.status(202).send(User.toJsonObject(event));
    }

    void createUser(ServerRequest serverRequest, ServerResponse serverResponse, JsonObject input) {
        User event = User.toUser(input);
        event = userService.createUser(event);
        serverResponse.status(201).send(User.toJsonObject(event));
    }

    void getAllUser(ServerRequest serverRequest, ServerResponse serverResponse) {
        serverResponse.status(200).send(UserList.toJsonObject(UserList.builder().users(userService.getAllUsers()).build()));
    }

    void getUser(ServerRequest serverRequest, ServerResponse serverResponse) {
        String id = serverRequest.path().param("id");
        User event = userService.getUserById(UUID.fromString(id));
        serverResponse.status(200).send(event != null ? User.toJsonObject(event) : null);
    }
}
