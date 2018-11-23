package com.senacor.hacking.days.event.service.handler.port;

import lombok.Builder;
import lombok.Data;

import javax.json.Json;
import javax.json.JsonObject;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class User {

    private UUID uuid;

    private String firstName;

    private String lastName;

    private List<UUID> attendingEvents;

    public static User toUser(JsonObject jsonObject) {
        return User.builder()
                .firstName(jsonObject.getString("firstName"))
                .lastName(jsonObject.getString("lastName"))
                .build();
    }

    public static JsonObject toJsonObject(User user) {
        return Json.createObjectBuilder()
                .add("uuid", user.getUuid().toString())
                .add("firstName", user.getFirstName())
                .add("lastName", user.getLastName())
                .build();
    }
}
