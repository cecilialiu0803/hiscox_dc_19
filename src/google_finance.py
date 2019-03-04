"""
Date created: 19/02/25
@author: ksuchak
A script to get hold of stock prices given a list of companies
"""

# Imports
from pandas_datareader import data
import matplotlib.pyplot as plt
import pandas as pd

# Read in initial company data
def read_company_data():
    """
    Read hiscox challenge company data.
    """
    df = pd.read_csv('../data/Company_NAIC.csv')
    return df

#hiscox_data = read_company_data()

# Read company-ticker data
# Taken from https://www.nasdaq.com/screening/company-list.aspx
def read_ticker_data(quiet=True):
    """
    Read in csv files to match up tickers and company names.
    Return total dataframe.
    """
    amex = pd.read_csv('../data/amex.csv')
    nasdaq = pd.read_csv('../data/nasdaq.csv')
    nyse = pd.read_csv('../data/nyse.csv')

    df = pd.concat([amex, nasdaq, nyse])

    if not quiet:
        print(df.shape)
        print(df.columns.values)
    return df

def read_more_ticker_data():
    """
    Read in csv file of ticker-company names.
    Taken from https://investexcel.net/all-yahoo-finance-stock-tickers/
    """
    df = pd.read_csv('../data/ticker_symbols.csv')
    return df

#ticker_data = read_more_ticker_data()
#print(ticker_data.head())
#print(ticker_data.shape)
#print(ticker_data[['ticker', 'name']].head())

# Get yahoo finance data for tickers
def get_data_from_tickers(tickers, start='2015-01-01', end='2018-12-31'):
    """
    Take a list of stock tickers, and get stock price data for them.
    """
    panel_data = data.DataReader(tickers, 'yahoo', start, end)
    close = panel_data['Close']
    all_weekdays = pd.date_range(start=start, end=end, freq='B')
    close = close.reindex(all_weekdays)
    close = close.fillna(method='ffill')
    return all_weekdays, close

# Run
def runner():
    """
    Function to run everything
    """
    # Get list of tickers
    tickers = ['AAPL', 'MSFT', '^GSPC']
    all_weekdays, close = get_data_from_tickers(tickers)
    # Print outputs
    print(all_weekdays)
    print(close.head(10))

    msft = close.loc[:, 'MSFT']

    # Construct rolling averages
    short_rolling_msft = msft.rolling(window=20).mean()
    long_rolling_msft = msft.rolling(window=100).mean()

    # Create plots of rolling averages
    fig, ax = plt.subplots(figsize=(16, 9))

    ax.plot(msft.index, msft, label='MSFT')
    ax.plot(short_rolling_msft.index, short_rolling_msft, label='20-day rolling')
    ax.plot(long_rolling_msft.index, long_rolling_msft, label='100-day rolling')

    ax.set_xlabel('date')
    ax.set_ylabel('adjusted closing price ($)')
    ax.legend()
    plt.show()

runner()
