#!/bin/bash
ssh -N -t -L9001:localhost:9001 -R9002:localhost:9002 sfodev5
