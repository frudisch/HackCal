package com.senacor.hacking.days.event.service.repository;

import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.senacor.hacking.days.event.service.repository.domain.Event;
import com.senacor.hacking.days.event.service.repository.domain.User;
import lombok.Getter;
import org.bson.codecs.configuration.CodecRegistry;
import org.bson.codecs.pojo.PojoCodecProvider;

import static com.mongodb.MongoClientSettings.getDefaultCodecRegistry;
import static org.bson.codecs.configuration.CodecRegistries.fromProviders;
import static org.bson.codecs.configuration.CodecRegistries.fromRegistries;

@Getter
public class MongoDB {

    private final MongoCollection<Event> eventCollection;
    private final MongoCollection<User> userCollection;

    public MongoDB() {
        CodecRegistry pojoCodecRegistry = fromRegistries(getDefaultCodecRegistry(),
                fromProviders(PojoCodecProvider.builder().automatic(true).build()));
        MongoClientSettings settings = MongoClientSettings.builder()
                .codecRegistry(pojoCodecRegistry)
                .build();
        MongoClient mongoClient = MongoClients.create(settings);

        eventCollection = mongoClient.getDatabase("calendar").getCollection("event", Event.class);
        userCollection = mongoClient.getDatabase("calendar").getCollection("user", User.class);
    }
}
