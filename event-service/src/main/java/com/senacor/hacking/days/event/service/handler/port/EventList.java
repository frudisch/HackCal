package com.senacor.hacking.days.event.service.handler.port;

import lombok.Builder;
import lombok.Data;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import java.util.Collection;

@Data
@Builder
public class EventList {

    private Collection<Event> events;

    public static JsonArray toJsonObject(EventList eventList) {
        JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
        eventList.events.forEach(event -> arrayBuilder.add(Event.toJsonObject(event)));
        return arrayBuilder
                .build();
    }
}
