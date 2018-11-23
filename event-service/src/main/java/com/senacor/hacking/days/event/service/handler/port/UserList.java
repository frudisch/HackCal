package com.senacor.hacking.days.event.service.handler.port;

import lombok.Builder;
import lombok.Data;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import java.util.Collection;

@Data
@Builder
public class UserList {

    private Collection<User> users;

    public static JsonArray toJsonObject(UserList userList) {
        JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
        userList.users.forEach(user -> arrayBuilder.add(User.toJsonObject(user)));
        return arrayBuilder
                .build();
    }
}
