package com.senacor.hacking.days.event.service.handler.port;

import lombok.Builder;
import lombok.Data;

import javax.json.Json;
import javax.json.JsonObject;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Data
@Builder
public class Event {

    private UUID uuid;

    private String name;

    private LocalDateTime date;

    private String description;

    public static Event toEvent(JsonObject jsonObject) {
        return Event.builder()
                .name(jsonObject.getString("name"))
                .date(LocalDateTime.parse(jsonObject.getString("date")))
                .description(jsonObject.get("description") != null ? jsonObject.getString("description") : null)
                .build();
    }

    public static JsonObject toJsonObject(Event event) {
        return Json.createObjectBuilder()
                .add("uuid", event.getUuid().toString())
                .add("name", event.getName())
                .add("date", event.getDate().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))
                .add("description", event.getDescription())
                .build();
    }
}
