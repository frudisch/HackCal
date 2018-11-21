package com.senacor.hacking.days.event.service.repository;

import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.senacor.hacking.days.event.service.repository.domain.Event;
import org.bson.codecs.configuration.CodecRegistry;
import org.bson.codecs.pojo.PojoCodecProvider;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

import static com.mongodb.MongoClientSettings.getDefaultCodecRegistry;
import static com.mongodb.client.model.Filters.eq;
import static org.bson.codecs.configuration.CodecRegistries.fromProviders;
import static org.bson.codecs.configuration.CodecRegistries.fromRegistries;

public class MongoDB {

    private final MongoCollection<Event> collection;

    public MongoDB() {
        CodecRegistry pojoCodecRegistry = fromRegistries(getDefaultCodecRegistry(),
                fromProviders(PojoCodecProvider.builder().automatic(true).build()));
        MongoClientSettings settings = MongoClientSettings.builder()
                .codecRegistry(pojoCodecRegistry)
                .build();
        MongoClient mongoClient = MongoClients.create(settings);

        collection = mongoClient.getDatabase("events").getCollection("event", Event.class);
    }

    public List<Event> selectEventsByName(String name) {
        return collection.find(eq("_name", name)).into(new ArrayList<>());
    }

    public Event selectEventByUuid(UUID uuid) {
        return collection.find(eq("_id", uuid)).first();
    }

    public void insertEvent(Event event) {
        collection.insertOne(event);
    }

    public Event findAndReplaceEvent(UUID uuid, Event event) {
        return collection.findOneAndReplace(eq("_id", uuid), event);
    }

    public Event deleteEvent(UUID uuid) {
        return collection.findOneAndDelete(eq("_id", uuid));
    }

    public List<Event> selectAllEvents() {
        return collection.find().into(new ArrayList<>());
    }
}
