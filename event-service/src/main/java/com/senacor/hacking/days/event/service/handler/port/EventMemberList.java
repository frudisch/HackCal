package com.senacor.hacking.days.event.service.handler.port;

import lombok.Builder;
import lombok.Data;

import javax.json.Json;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Data
@Builder
public class EventMemberList {

    private UUID event;

    private List<UUID> member;

    public static EventMemberList toEventMemberList(JsonObject jsonObject) {
        return EventMemberList.builder()
                .event(UUID.fromString(jsonObject.getString("uuid")))
                .member(jsonObject.getJsonArray("member").stream().map(entry -> UUID.fromString(entry.toString())).collect(Collectors.toList()))
                .build();
    }

    public static JsonObject toJsonObject(EventMemberList eventMemberList) {
        JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
        eventMemberList.member.forEach(member -> arrayBuilder.add(member.toString()));
        return Json.createObjectBuilder()
                .add("event", eventMemberList.getEvent().toString())
                .add("member", arrayBuilder.build())
                .build();
    }
}
