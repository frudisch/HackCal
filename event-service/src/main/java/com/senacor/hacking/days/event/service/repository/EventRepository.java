package com.senacor.hacking.days.event.service.repository;

import com.senacor.hacking.days.event.service.repository.domain.Event;
import lombok.AllArgsConstructor;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static com.mongodb.client.model.Filters.eq;

@AllArgsConstructor
public class EventRepository {

    private final MongoDB mongoDB;

    public List<Event> selectEventsByName(String name) {
        return mongoDB.getEventCollection().find(eq("name", name)).into(new ArrayList<>());
    }

    public Event selectEventByUuid(UUID uuid) {
        return mongoDB.getEventCollection().find(eq("_id", uuid)).first();
    }

    public void insertEvent(Event event) {
        mongoDB.getEventCollection().insertOne(event);
    }

    public Event findAndReplaceEvent(UUID uuid, Event event) {
        return mongoDB.getEventCollection().findOneAndReplace(eq("_id", uuid), event);
    }

    public Event deleteEvent(UUID uuid) {
        return mongoDB.getEventCollection().findOneAndDelete(eq("_id", uuid));
    }

    public List<Event> selectAllEvents() {
        return mongoDB.getEventCollection().find().into(new ArrayList<>());
    }
}
