package com.senacor.hacking.days.event.service.handler.response;

import lombok.Builder;
import lombok.Data;

import javax.json.Json;
import javax.json.JsonObject;
import java.time.LocalDate;
import java.util.UUID;

@Data
@Builder
public class Event {

    private UUID uuid;

    private String name;

    private LocalDate date;

    private String description;

    public static Event toEvent(JsonObject jsonObject) {
        return Event.builder()
                .name(jsonObject.getString("name"))
                .date(null)
                .description(jsonObject.getString("description"))
                .build();
    }

    public static JsonObject toJsonObject(Event event) {
        return Json.createObjectBuilder()
                .add("uuid", event.getUuid().toString())
                .add("name", event.getName())
                .add("date", LocalDate.of(2018, 11, 20).toString())
                .add("description", event.getDescription())
                .build();
    }
}
