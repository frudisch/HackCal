package com.senacor.hacking.days.event.service.handler;

import com.senacor.hacking.days.event.service.handler.response.Event;
import com.senacor.hacking.days.event.service.handler.response.EventList;
import io.helidon.webserver.Handler;
import io.helidon.webserver.Routing;
import io.helidon.webserver.ServerRequest;
import io.helidon.webserver.ServerResponse;
import io.helidon.webserver.Service;
import io.helidon.webserver.json.JsonSupport;

import javax.json.JsonObject;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class EventService implements Service {

    private Map<UUID, Event> store = new HashMap<>();

    @Override
    public void update(Routing.Rules rules) {
        rules
                .register(JsonSupport.get())
                .get("/{id}", this::getEventById)
                .get("/", this::getAllEvents)
                .delete("/{id}", this::deleteEvent)
                .post("/", Handler.of(JsonObject.class, this::createEvent))
                .put("/", Handler.of(JsonObject.class, this::updateEvent));
    }

    private void deleteEvent(ServerRequest serverRequest, ServerResponse serverResponse) {
        String id = serverRequest.path().param("id");
        Event event = store.remove(UUID.fromString(id));
        serverResponse.send(event != null ? Event.toJsonObject(event) : null);
    }

    private void updateEvent(ServerRequest serverRequest, ServerResponse serverResponse, JsonObject input) {
        Event event = Event.toEvent(input);
        store.put(event.getUuid(), event);
        serverResponse.send(Event.toJsonObject(event));
    }

    private void createEvent(ServerRequest serverRequest, ServerResponse serverResponse, JsonObject input) {
        Event event = Event.toEvent(input);
        event.setUuid(UUID.randomUUID());
        store.put(event.getUuid(), event);
        serverResponse.send(Event.toJsonObject(event));
    }

    private void getAllEvents(ServerRequest serverRequest, ServerResponse serverResponse) {
        serverResponse.send(EventList.toJsonObject(EventList.builder().events(store.values()).build()));
    }

    private void getEventById(ServerRequest serverRequest, ServerResponse serverResponse) {
        String id = serverRequest.path().param("id");
        Event event = store.get(UUID.fromString(id));
        serverResponse.send(event != null ? Event.toJsonObject(event) : null);
    }
}
