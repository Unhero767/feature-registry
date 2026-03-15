"""
List Features CLI (Rule #11: Feature ownership visibility)
Displays all registered features with owner and status.
Author: Kenneth Dallmier | kennydallmier@gmail.com
"""

import os
import sys


def list_features(db_conn_string: str) -> None:
    """Print all registered features from the feature registry."""
    try:
        import psycopg2
    except ImportError:
        print("ERROR: psycopg2 not installed. Run: pip install psycopg2-binary")
        sys.exit(1)

    try:
        conn = psycopg2.connect(db_conn_string)
        with conn.cursor() as cur:
            cur.execute("""
                SELECT feature_name, owner_email, data_type,
                       expected_coverage_pct, status, created_at
                FROM feature_registry
                ORDER BY status, feature_name
            """)
            rows = cur.fetchall()
        conn.close()
    except Exception as e:
        print(f"ERROR: Could not connect to database: {e}")
        sys.exit(1)

    print(f"\n{'='*70}")
    print(f"MLAOS Feature Registry (Rule #11)")
    print(f"Total features: {len(rows)}")
    print(f"{'='*70}")
    print(f"{'Feature':<30} {'Owner':<30} {'Type':<8} {'Coverage':>8} {'Status':>12}")
    print(f"{'-'*70}")

    for row in rows:
        feature_name, owner, dtype, coverage, status, created = row
        status_icon = '✅' if status == 'ACTIVE' else '⚠️' if status == 'DEPRECATED' else '🧪'
        print(f"{feature_name:<30} {owner:<30} {dtype:<8} {coverage:>7.1f}% {status_icon} {status:>10}")

    print(f"{'='*70}\n")


if __name__ == '__main__':
    db_conn = os.environ.get('DATABASE_URL', '')
    if not db_conn:
        print("ERROR: DATABASE_URL environment variable not set.")
        print("Usage: DATABASE_URL=postgresql://... python scripts/list_features.py")
        sys.exit(1)
    list_features(db_conn)
