--C:\Program Files\MongoDB\Server\3.2\bin\mongo.exe
--mongoimport --db test --collection person_col --drop < C:\Users\MaciekKubicki\Desktop\PracaInzynierska\GetJSON\GetJSON\person.json
db.person_col.find().count();
db.person_col.find().pretty();
db.person_col.find().explain("executionStats");
db.person_col.stats();
db.person_col.totalSize();
db.person_col.storageSize();
db.person_col.find({"email"})
db.person_col.find({ "email": { $exists: true, $ne: null} });
db.person_col.find({ "email": { $exists: null, $ne: true} }).count();
db.person_col.find({ "email": {$size: 2 } });
db.person_col.find({ },{"email":1);

db.person_col.find({ },{"email":0}).explain("executionStats"); 
db.person_col.find({"person":{"LastName": /T.*/}, "email": {$size: 2 }});
db.person_col.find({$where: "this.person.LastName.toLowerCase().indexOf('T') == 0"})
db.person_col.aggregate([
    {"$group" : {_id:"$person.LastName", count:{$sum:1}}}
])
db.person_col.find().pretty();
db.person_col.find({$where: "this.address == '{\"city\":\"Bellevue\"}'"}); --nie działa
db.person_col.find({$where: "this.address.city == 'Bellevue'"}).count();
db.person_col.findAndModify({
query:{"email": { $exists: null, $ne: true}},
update:{$set:{'email': [$LastName]}},
new: true
});

db.person_col.find({"email": { $exists: null, $ne: true}}).limit(3).snapshot().forEach(
    function (elem) {
	db.person_col.update(
            {
                _id: elem._id
            },
            {
                $set: {
                    'email': [ elem.LastName +'@new.com']
                }
            }
        );
    }
);

db.person_col.find({}).sort({"person.personID": -1}).limit(1);

db.person_col.find({$where: "this.person.personID >= 18000"}).count();
db.person_col.remove({$where: "this.person.personID >= 18000"});
db.person_col.distinct("address.city").sort();