import Icrc1Ledger "canister:icrc1_ledger_canister";
import Error "mo:base/Error";
import Blob "mo:base/Blob";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";


actor {

  type Account = {  
    owner: Principal;
    subaccount: ?[Nat8];
   
  };

  type TransferArgs={
    amount: Nat8;
    toAccount: Account;
  };
  
  public shared ({caller}) func transfer(args: TransferArgs): async Result.Result<Icrc1Ledger.BlockIndex, Text>{
    Debug.print(
      "Transfering"
      # debug_show(args.amount)
      # "token to account"
      # debug_show(args.toAccount)
  
    );

    let transferArgs: Icrc1Ledger.TransferArgs={
      memory= null;
      amount= args.amount;
      from_subaccount= null;
      fee=null;
      to = args.toAccount;
      created_at_time= null;
    };

    try{
      let transferResult = await Icrc1Ledger.icrc1_transfer(transferArgs);

      switch(transferResult) {
        case(#Err(transferError)) { 
          #err("could not transfer funds:\n" # debug_show(transferError));
         };
      
        case(#Ok(blockIndex)) { 
          return #ok(blockIndex);
        };
      
      };
    }
    catch(error :Error) {
      #err("rejected:" #Error.message(error));
  };


  }
}

