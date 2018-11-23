package com.senacor.hacking.days.event.service.repository;

import com.senacor.hacking.days.event.service.repository.domain.User;
import lombok.AllArgsConstructor;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Filters.in;

@AllArgsConstructor
public class UserRepository {

    private final MongoDB mongoDB;

    public List<User> selectAllUserByEventId(UUID eventId) {
        return mongoDB.getUserCollection().find(in("attendingEvents", eventId)).into(new ArrayList<>());
    }

    public User findAndReplaceUser(UUID uuid, User user) {
        return mongoDB.getUserCollection().findOneAndReplace(eq("_id", uuid), user);
    }

    public void createUser(User user) {
        mongoDB.getUserCollection().insertOne(user);
    }

    public User deleteUser(UUID uuid) {
        return mongoDB.getUserCollection().findOneAndDelete(eq("_id", uuid));
    }

    public User selectUserById(UUID uuid) {
        return mongoDB.getUserCollection().find(eq("_id", uuid)).first();
    }

    public List<User> selectAllUsers() {
        return mongoDB.getUserCollection().find().into(new ArrayList<>());
    }
}
