#!/usr/bin/env python
# coding: utf-8

# In[1]:


import kaggle
import zipfile as zf
import pandas as pd
import mysql.connector
import sqlalchemy as sal
from urllib.parse import quote_plus


# In[2]:


get_ipython().system('kaggle datasets download ankitbansal06/retail-orders -f orders.csv')


# In[3]:


zip_ref = zf.ZipFile('orders.csv.zip')
zip_ref.extractall()
zip_ref.close()


# In[4]:


df = pd.read_csv('orders.csv',na_values=['Not Available', 'unknown'])
df.head(10)
df['Ship Mode'].unique()


# In[5]:


df.columns = df.columns.str.lower()
df.columns = df.columns.str.replace(' ','_')
df.head(10)


# In[6]:


df['discount'] = df['list_price']*df['discount_percent']*.01
df['sale_price'] = df['list_price']-df['discount']
df['profit'] = df['sale_price']-df['cost_price']


# In[7]:


df['order_date'] = pd.to_datetime(df['order_date'],format = "%Y-%m-%d")
# df.dtypes


# In[8]:


df.drop(columns=['list_price'],inplace=True)


# In[9]:


DB_USER = 'USERNAME'
DB_PASSWORD = 'Password'
DB_HOST = "Hostname"
DB_NAME = 'schema_name'
DB_PORT = Portname


# In[10]:



password = quote_plus("DB_PASSWORD") 
engine = sal.create_engine(f"mysql+pymysql://{DB_USER}:{password}@{DB_HOST}:{DB_PORT}/{schema_name}")
conn=engine.connect()


# In[11]:


df.to_sql('df_orders', con=conn , index=False, if_exists = 'append')


# In[12]:


df.columns


# In[30]:


get_ipython().system('jupyter nbconvert --to script orders_data_analysis.ipynb')


# In[ ]:




