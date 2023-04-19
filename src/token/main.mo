import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";



actor Token {
    Debug.print("hello");

    let owner : Principal = Principal.fromText("tcfmm-ollwm-s2ige-qktp3-macgc-zuis2-vjmru-dv6ty-evhrh-oahgl-uae");
    let totalSupply : Nat = 1000000000;
    let symbol: Text = "AANG";
    
    private stable var balanceEntries: [(Principal, Nat)] = [];

    // no other class or class or canister will be able to modify it
    private var balances = HashMap.HashMap<Principal,Nat>(1,Principal.equal,Principal.hash);
    if (balances.size() < 1) {
            balances.put(owner, totalSupply);
    };

    public query func balanceOf(who: Principal) : async Nat {

        let balance : Nat = switch(balances.get(who)) {
            case null 0;
            case (?result) result;
    };

    return balance;
    };

    public query func getSymbol() : async Text {
        return symbol;
    };

    // by using shard keyword we can get hold of the caller of the function
    public shared(msg) func payOut() : async Text {
        Debug.print(debug_show(msg.caller));  // <= to check the anonymous user id
        if (balances.get(msg.caller) == null) {
            let amount = 10000;
            let result = await transfer(msg.caller, amount);
            return result;
        } else {
            return "Already claimed";
        }
    };

    public shared(msg) func transfer(to: Principal, amount: Nat) :async Text {
        let fromBalance = await balanceOf(msg.caller); 
        if (fromBalance > amount) {
            let newBalance : Nat = fromBalance - amount;
            balances.put(msg.caller, newBalance);

            let toBalance = await balanceOf(to);
            let newToBalance = toBalance + amount;
            balances.put(to, newToBalance);

            return "Success";  
        } else {
            return "Insufficient Funds"
        }
    };


    system func preupgrade() {
        balanceEntries := Iter.toArray(balances.entries());
    };

    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
        if (balances.size() < 1) {
            balances.put(owner, totalSupply);
        }
    };

}