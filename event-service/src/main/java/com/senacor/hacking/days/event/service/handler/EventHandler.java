package com.senacor.hacking.days.event.service.handler;

import com.senacor.hacking.days.event.service.handler.response.Event;
import com.senacor.hacking.days.event.service.handler.response.EventList;
import com.senacor.hacking.days.event.service.service.EventService;
import io.helidon.webserver.Handler;
import io.helidon.webserver.Routing;
import io.helidon.webserver.ServerRequest;
import io.helidon.webserver.ServerResponse;
import io.helidon.webserver.Service;
import io.helidon.webserver.json.JsonSupport;

import javax.json.JsonObject;
import java.util.UUID;

public class EventHandler implements Service {

    private final EventService eventService;

    public EventHandler(EventService eventService) {
        this.eventService = eventService;
    }

    @Override
    public void update(Routing.Rules rules) {
        rules
                .register(JsonSupport.get())
                .get("/{id}", this::getEventById)
                .delete("/{id}", this::deleteEvent)
                .put("/{id}", Handler.of(JsonObject.class, this::updateEvent))
                .get("/", this::getAllEvents)
                .post("/", Handler.of(JsonObject.class, this::createEvent));
    }

    void deleteEvent(ServerRequest serverRequest, ServerResponse serverResponse) {
        String id = serverRequest.path().param("id");
        eventService.deleteEvent(UUID.fromString(id));
        serverResponse.send();
    }

    void updateEvent(ServerRequest serverRequest, ServerResponse serverResponse, JsonObject input) {
        String id = serverRequest.path().param("id");
        Event event = eventService.updateEvent(UUID.fromString(id), Event.toEvent(input));
        serverResponse.send(Event.toJsonObject(event));
    }

    void createEvent(ServerRequest serverRequest, ServerResponse serverResponse, JsonObject input) {
        Event event = Event.toEvent(input);
        event = eventService.createEvent(event);
        serverResponse.send(Event.toJsonObject(event));
    }

    void getAllEvents(ServerRequest serverRequest, ServerResponse serverResponse) {
        serverResponse.send(EventList.toJsonObject(EventList.builder().events(eventService.getAllEvents()).build()));
    }

    void getEventById(ServerRequest serverRequest, ServerResponse serverResponse) {
        String id = serverRequest.path().param("id");
        Event event = eventService.getEventById(UUID.fromString(id));
        serverResponse.send(event != null ? Event.toJsonObject(event) : null);
    }
}