import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Timer "mo:base/Timer";

import HTTP "Http";
import IC "Ic";
import Type "Types";

actor class Verifier() {
  type StudentProfile = Type.StudentProfile;

  let natHash = func(n : Nat) : Hash.Hash = Text.hash(Nat.toText(n));
  var studentProfileStore = HashMap.HashMap<Principal, StudentProfile>(1, Principal.equal, Principal.hash);

  // STEP 1 - BEGIN
  public shared ({ caller }) func addMyProfile(profile : StudentProfile) : async Result.Result<(), Text> {
    studentProfileStore.put(caller, profile);
    return #ok();
  };

  public shared ({ caller }) func seeAProfile(p : Principal) : async Result.Result<StudentProfile, Text> {
    let student = studentProfileStore.get(p);
    switch (student) {
      case (null) return #err("El estudiante no es esta registrado");
      case (?student) return #ok(student);
    };
  };

  public shared ({ caller }) func updateMyProfile(profile : StudentProfile) : async Result.Result<(), Text> {
    let student = studentProfileStore.replace(caller, profile);
    switch (student) {
      case (null) return #err("El estudiante no es esta registrado");
      case (?student) return #ok();
    };
  };

  public shared ({ caller }) func deleteMyProfile() : async Result.Result<(), Text> {
    let student = studentProfileStore.remove(caller);
    switch (student) {
      case (null) return #err("El estudiante no es esta registrado");
      case (?student) return #ok();
    };
  };
  // STEP 1 - END

  // STEP 2 - BEGIN
  type calculatorInterface = Type.CalculatorInterface;
  public type TestResult = Type.TestResult;
  public type TestError = Type.TestError;

  public func test(canisterId : Principal) : async TestResult {

    var value: Int = 0;
    let calculator = actor (Principal.toText(canisterId)) : actor {
      add : (n : Int) -> async Int;
      sub : (n : Nat) -> async Int;
      reset : () -> async Int;
    };
    
    value := await calculator.add(3);
    if(value != 3) return #err(#UnexpectedValue("add not fun"));
    value := await calculator.sub(1);
    if(value != 2) return #err(#UnexpectedValue("sub not fun"));
    value := await calculator.reset();
    if(value != 0) return #err(#UnexpectedValue("reset not fun"));
    return #ok();
  };
  // STEP - 2 END

  // STEP 3 - BEGIN
  // NOTE: Not possible to develop locally,
  // as actor "aaaa-aa" (aka the IC itself, exposed as an interface) does not exist locally
  public func verifyOwnership(canisterId : Principal, p : Principal) : async Result.Result<Bool, Text> {
    return #err("not implemented");
  };
  // STEP 3 - END

  // STEP 4 - BEGIN
  public shared ({ caller }) func verifyWork(canisterId : Principal, p : Principal) : async Result.Result<Bool, Text> {
    return #err("not implemented");
  };
  // STEP 4 - END

  // STEP 5 - BEGIN
  public type HttpRequest = HTTP.HttpRequest;
  public type HttpResponse = HTTP.HttpResponse;

  // NOTE: Not possible to develop locally,
  // as Timer is not running on a local replica
  public func activateGraduation() : async () {
    return ();
  };

  public func deactivateGraduation() : async () {
    return ();
  };

  public query func http_request(request : HttpRequest) : async HttpResponse {
    return ({
      status_code = 200;
      headers = [];
      body = Text.encodeUtf8("");
      streaming_strategy = null;
    });
  };
  // STEP 5 - END
};