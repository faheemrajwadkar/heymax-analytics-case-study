import streamlit as st
import pandas as pd
import plotly.express as px
import duckdb

def render_engagement_dashboard():
    st.sidebar.header("Engagement Filters")
    # Let users zoom into the first 30, 60, or 90 days of a user's life
    day_limit = st.sidebar.slider("Days Since Signup (Max)", 7, 90, 30, key="eng_day_slider")

    try:
        df = pd.read_csv('modules/data_engagement.csv')

        # filter
        df = df.loc[df['days_since_signup'] <= day_limit]

        if not df.empty:
            # Aggregate to see the "Average User Journey" across all cohorts
            avg_journey = df.groupby('days_since_signup')['events_per_user'].mean().reset_index()

            # Chart: The Lifecycle Curve
            fig = px.line(
                avg_journey,
                x='days_since_signup',
                y='events_per_user',
                title="Average User Engagement Lifecycle",
                labels={'days_since_signup': 'Days Since Account Activation', 'events_per_user': 'Avg Events per User'},
                markers=True
            )
            
            # Add a reference line for Day 0 (Initial hype)
            st.plotly_chart(fig, use_container_width=True)

            st.info("""
            **How to read this:**  
            - A steep drop after Day 0 is normal. 
            - If the line levels out (the 'flattening of the curve'), it means you've achieved product-market fit for that segment.
            """)

            with st.expander("View Raw Lifecycle Data"):
                st.dataframe(df)
        else:
            st.info("No engagement data found.")

    except Exception as e:
        st.error(f"Engagement Tab Error: {e}")