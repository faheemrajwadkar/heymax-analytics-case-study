import streamlit as st
import pandas as pd
import plotly.express as px
import duckdb

def render_growth_dashboard():
    try:
        # 1. Load Data
        df = pd.read_csv('modules/data_growth.csv')
        
        df['dt'] = pd.to_datetime(df['dt'])

        # 2. Localized Sidebar Filters
        st.sidebar.header("Growth Filters")
        
        period = st.sidebar.selectbox(
            "Select Periodicity", 
            options=df['period'].unique(), 
            key="growth_period_selector"
        )
        
        min_date = df['dt'].min().to_pydatetime()
        max_date = df['dt'].max().to_pydatetime()
        
        date_range = st.sidebar.slider(
            "Select Date Range",
            min_value=min_date,
            max_value=max_date,
            value=(min_date, max_date),
            key="growth_date_slider"
        )

        # 3. Apply Filters
        mask = (df['period'] == period) & \
               (df['dt'] >= pd.to_datetime(date_range[0])) & \
               (df['dt'] <= pd.to_datetime(date_range[1]))
        
        f_df = df.loc[mask].sort_values('dt')

        if f_df.empty:
            st.warning("No data found for this selection.")
            return

        # 4. KPI Section (Latest vs Previous)
        if len(f_df) >= 2:
            latest = f_df.iloc[-1]
            prev = f_df.iloc[-2]
            
            st.subheader(f"Snapshot: {latest['dt'].strftime('%Y-%m-%d')}")
            cols = st.columns(4)
            
            metrics = [
                ("New Users", 'new_users', False),
                ("Retained", 'retained_users', False),
                ("Resurrected", 'resurrected_users', False),
                ("Churned", 'churned_users', True)
            ]

            for i, (label, col_name, inv) in enumerate(metrics):
                curr_val = latest[col_name]
                prev_val = prev[col_name]
                delta = ((curr_val - prev_val) / prev_val * 100) if prev_val != 0 else 0
                
                with cols[i].container(border=True):
                    st.metric(label, f"{int(curr_val):,}", f"{delta:.1f}%", delta_color="inverse" if inv else "normal")

        # 5. Charts
        st.markdown("---")
        
        # Stacked Bar (Active Users)
        plot_df = f_df.melt(id_vars=['dt'], value_vars=['new_users', 'retained_users', 'resurrected_users'],
                            var_name='Status', value_name='Users')
        
        fig = px.bar(
            plot_df, 
            x='dt', 
            y='Users', 
            color='Status', 
            title="Active User Composition",
            labels={
                'user_count': 'Users', 
                'dt': 'Date', 
                'status': 'Category',
                'new_users': 'New Users',
                'retained_users': 'Retained Users',
                'resurrected_users': 'Resurrected Users'
            },
            color_discrete_map={'new_users': '#2ecc71', 'retained_users': '#3498db', 'resurrected_users': '#f1c40f'})
        st.plotly_chart(fig, use_container_width=True)

        # Churn Line
        fig_churn = px.line(
            f_df, 
            x='dt', 
            y='churned_users', 
            title="Churn Trend", 
            labels={'churned_users': 'Churned Users', 'dt': 'Date'},
            color_discrete_sequence=['#e74c3c']
        )
        st.plotly_chart(fig_churn, use_container_width=True)

    except Exception as e:
        st.error(f"Growth Tab Error: {e}")