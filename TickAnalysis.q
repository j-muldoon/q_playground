/ ideally we seed the random generator

/ GLOBAL list of symbols for companies
SYMS: `aapl`goog`ibm

/ n is number of trades to generate
createTrades:{ [n];
    tms:n?24:00:00.000000000; /times within a day
    syms: n? SYMS;
    vols:10*1+n?1000;
    pxs:90.0 + (n?2001) % 100;

    / Final entry is what is returned (do not put semicolon after)
    `tm xasc ([] tm:tms; sym:syms; vol:vols; px:pxs)
    };

createQuotes:{[n]
    tms: n?24:00:00.000000000;
    syms: n? SYMS;

    mid: 90.0 + (n?2001)%100;
    spread: 0.01 + (n?5)%100;

    bids: mid - spread % 2;

    `tm xasc ([] tm:tms; sym:syms; bid:bids; ask:asks)
    };

tr:createTrades 1000
qu: createQuotes 1000


/ https://code.kx.com/q/kb/programming-idioms/#how-do-i-calculate-vwap-series was useful for the following

/ If you want VWAP for all symbols, just pass the global list of SYMS, not sure how to do default arguments in this language yet

/ Copied from 9.13.5 in Q for mortals
/ Haven't fully figured out what is going on here
/ TODO: Study this function
dopivot:{[t; kn; pn; vn]
    P:?[t; (); (); (distinct; pn)];
    ?[t;(); (1#kn)!1#kn; (#;`P;(!;pn;vn))]}

VWAP:{[table; symList]
    pos_table: select from table where sym in symList, vol > 0;

    v_table: select vwap:vol wavg px by sym, 5 xbar tm.minute from pos_table;

    dopivot [v_table; `minute; `sym; `vwap]
    }

/should create file in current working directory
vwap_csv:{[table]
    / note: I am not using set, as I don't want to inadvertently generate 1000000000 row csv and take up storage on my computer and 0: comes with a data limit from what I can tell
    `:vwap.csv 0: csv 0: table
 }

/ copy below in q REPL to generate VWAP csv
/ vwap_csv VWAP [tr; SYMS]


/TODO: Volume by hour


/TODO: Trade count per symbol


/TODO: Quote spread over time


/TODO: OHLC Bars (Generate candelstick data)


/TODO: Real-Time Simulation


/TODO: Persist to Disk

