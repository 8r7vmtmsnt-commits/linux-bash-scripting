#!/bin/bash

echo "Top 10 Processes"
ps aux --sort=-%cpu | head
