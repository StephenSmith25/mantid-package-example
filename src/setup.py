from setuptools import find_packages, setup

setup(
    name='m_window', 
    version="0.1.0",
    packages=find_packages(exclude=['*.test']),
    entry_points={
        "gui_scripts": [
            "m_window = m_window.main:main"
        ]
    },
    )