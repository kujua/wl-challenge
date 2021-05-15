## Challenge

### Installation 

I have added two aliases to mix: 
- **mix c** gets dependencies, compiles, formats and runs credo and dialyzer
- **mix test**  runs the tests and coverage with ExCoveralls

### Application Overview

The user can submit a transaction hash and will get a message if the submit was succesful. The hash is validated with a simple regex. 

When a hash is confirmed twice, i.e. two additional blocks were created,a HTML table in the UI will be updated with the record of the successfully submitted transaction. The user does not need to press a button or perform any other input to see the updates over time.

### Implementation Details

The application is implemented with Phoenix including live view component and channels, a GenServer for the API, a scheduled GenServer for the simulation of block creation and an Agent as data store for transactions.

No database was used for this application.

When the user presses the submit button a function in the API server is called, which sends a message to itself. After successful validation of the hash a transaction struct is created (with the *hash*, the current *block number* and a *timestamp*) and stored in the data store Agent.

The simulated block miner casts a message to the API server whenever a new block is created. The server then gets the list of successful transactions from the data store and broadcasts a message via a channel to the *TableLive* component which updates over the live view mechanism the table in the UI.

The UI implementation does not use any framework or CSS libraries. 

I have not deleted certain files and folders that were created during *phx.new*.

### Caveats

- This simple application is single user / single server. This means that another user would see all sucessful transactions, either submitted by the user or not. I added a field *client_id* in the transaction structure, but did not implement it.
- All data is held in memory. When the application is closed or restarted all data is lost.
- There is no check if the txhash was already submitted
- The mock miner runs in the background as long as the application runs, so could eventually run out of memory.
- The data store does not purge records, so coudl also run out of memory after a long period.
