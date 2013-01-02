## Steps to test your connection

1. Fill in your database credentials into the PG.connect params
2. Create iron.json (explained [here](http://dev.iron.io/worker/reference/configuration/))
3. `iron_worker upload pgconnect`
4. `iron_worker queue pgconnect`
5. Check the log of your worker task task to see the results


